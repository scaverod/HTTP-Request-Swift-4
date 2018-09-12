//
//  Created by Sergio Cavero Diaz on 08/08/2018.
//  Copyright © 2018 Sergio Cavero Diaz. All rights reserved.
//

import Foundation

class ServerController {
    
    // API Root:
    static let domain = "your URL"
    
    // API Method Allowed:
    enum RequestType {
        case POST
        case GET
        case DELETE
    }
    
    
    /// Make a request to the server.
    ///
    /// - Parameters:
    ///     - type: Type of the call (POST, GET, DELETE).
    ///     - url: where it should be send the request.
    ///     - token: for the authentication, barear's value. It could be "" if is not needed.
    ///     - params: It will be added to the body in post calls. It could be "" if is not needed.
    /// - Returns:
    ///     - Int: Http status code.
    ///     - Data: Data response.
    static func makeRequest(type: RequestType, url: String, token: String, params: String) -> (Int, Data){
        switch type {
        case RequestType.DELETE:
            return makeDeleteRequest(url: url, token: token)
        case RequestType.GET:
            return makeGetRequest(url: url, token: token)
        default:
            return makePostRequest(url: url, token: token, params: params)
        }
    }
    
    
    private static func makeDeleteRequest( url: String, token: String) -> (Int, Data) {
        var request = createRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        return createTask(request: request)
    }
    
    private static func makeGetRequest(url: String, token: String) -> (Int, Data){
        var request = createRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return createTask(request: request)
    }
    
    private static func makePostRequest(url: String, token: String, params: String) -> (Int, Data){
        var request = createRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = params.data(using: .utf8)
        return createTask(request: request)
    }
    
    
    private static func createRequest (url: String) -> URLRequest{
        return URLRequest(url: URL(string: domain + url)!)
    }
    
    private static func createTask (request: URLRequest) -> (Int, Data){
        var done = false
        var code: Int?
        var dataResponse: Data?
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Server Controller -> Error creating the task= \n \(String(describing: error))")
                code = 503
                dataResponse = "The Internet connection appears to be offline".data(using: .utf8)
                done = true
                return
            }
            let httpStatus = response as? HTTPURLResponse
            code = httpStatus?.statusCode
            dataResponse = data
            done = true
        }
        task.resume()
        repeat{
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.000000000001))
        }while !done
        return (code!, dataResponse!)
    }
    
    
}
