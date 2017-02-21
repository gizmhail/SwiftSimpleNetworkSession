/*
 Copyright 2017 Sébastien Poivre
 Licensed under MIT license
 */

import Foundation
import Dispatch

// Iherits from object to be able to use index:of: on tasks list
class SimpleDataTask: NSObject {
    var url:URL?
    var completionHandler:((Data?, Error?) -> ())?
    
    override init(){
        
    }
    
    init(url:URL, completionHandler:@escaping (Data?, Error?) -> ()) {
        self.url = url
        self.completionHandler = completionHandler
    }
    
    func resume(){
        guard #available(OSX 10.10, *) else {return}
        
        if let url = url {
            DispatchQueue.global(qos: .default).async { [weak self] in
                do {
                    let result = try Data(contentsOf: url)
                    self?.completionHandler?(result, nil)
                } catch {
                    self?.completionHandler?(nil, error)
                }
            }
        }
    }
}

class SimpleNetworkSession {
    open static let shared = SimpleNetworkSession()
    
    private var tasks:[SimpleDataTask] = []
    
    open func dataTask(with url: URL, completionHandler: @escaping (Data?, Error?) -> ()) -> SimpleDataTask {
        let task = SimpleDataTask()
        task.url = url
        task.completionHandler = { [weak self] (data, error) in
            if let index = self?.tasks.index(of: task) {
                self?.tasks.remove(at: index)
            }
            completionHandler(data, error)
        }
        tasks.append(task)
        return task
    }
}

// MARK: JSON helper method
extension SimpleNetworkSession {
    open func jsonTask(with url: URL, completionHandler: @escaping (Any?, Error?) -> ()) -> SimpleDataTask {
        return dataTask(with: url, completionHandler: { (data, error )in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completionHandler(json, nil)
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, error)
            }
        })
    }
}

func test() {
    let token =  "587c733af90799fde4b565eeb6532d05"
    if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Rennes&APPID=\(token)") {
        let task = SimpleNetworkSession.shared.jsonTask(with: url){ (json, error) in
            print("\(json)")
        }
        task.resume()
    }
    while true {
        print("Waiting...")
        sleep(1)
    }
}

