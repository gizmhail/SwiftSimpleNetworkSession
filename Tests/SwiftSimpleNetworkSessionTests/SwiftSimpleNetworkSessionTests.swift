/*
 Copyright 2017 Sébastien Poivre
 Licensed under MIT license
 */
import XCTest
@testable import SwiftSimpleNetworkSession

class SwiftSimpleNetworkSessionTests: XCTestCase {
    func testSimpleNetworkSessionDataTask() {
        let expectation = self.expectation(description: "Testing Data answer")
        
        if let url = URL(string: "https://google.fr") {
            let task = SimpleNetworkSession.shared.dataTask(with: url){ (data, error) in
                print("\(data)")
                expectation.fulfill()
            }
            task.resume()
        }
        self.waitForExpectations(timeout: 10) { (error) in
            
        }
    }
    
    func testSimpleNetworkSessionJSONTask() {
        let expectation = self.expectation(description: "Testing Data answer")
        
        guard let token = ProcessInfo.processInfo.environment["WEATHER_TOKEN"]  else {
            XCTFail("Pleaser set WEATHER_TOKEN environment variable to a valid api.openweathermap.org API token to test JSON answer")
            return
        }
        
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Rennes&APPID=\(token)") {
            let task = SimpleNetworkSession.shared.jsonTask(with: url){ (json, error) in
                print("\(json)")
                expectation.fulfill()
            }
            task.resume()
        }
        self.waitForExpectations(timeout: 10) { (error) in
            
        }
    }


    static var allTests : [(String, (SwiftSimpleNetworkSessionTests) -> () throws -> Void)] {
        return [
            ("testExample", testSimpleNetworkSessionJSONTask),
        ]
    }
}
