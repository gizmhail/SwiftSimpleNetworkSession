Simple Swift package to launch simple asynchronous network request

Context 
==========
On Linux, as of Swift 3.02, URLSession.shared is not yet available in Foundation. Hence, it is somewhat difficult to quickly send an http request.

This package simply rely on DispatchQueue to asynchronously use synchronous calls, that are available.

Purpose
===========
Mainly for test and educational purposes, waiting for URLSession to be fully implemented in Fundation

License
==========
MIT License

Usage
========
```swift 
if let url = URL(string: "https://google.fr") {
    let task = SimpleNetworkSession.shared.dataTask(with: url){ (data, error) in
        //....
    }
    task.resume()
}
```

```swift
let town = "Rennes"
let token = ... // Valid api.openweathermap.org API token
if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(town)&APPID=\(token)") {
    let task = SimpleNetworkSession.shared.jsonTask(with: url){ (json, error) in
        print("\(json)")
    }
    task.resume()
}
```
