//
//  BoltService.swift
//  Bolt
//
//  Created by Darshan Mothreja on 1/18/18.
//  Copyright © 2018 Darshan Mothreja. All rights reserved.
//

import UIKit

// Configure your base URL.
let BaseURL = "https://api.github.com/search/users?q=location:india&sort=stars&order=asce&page=1&p er_page=100"

public enum HTTPMethod: String {
    case get                         = "GET"
    case post                        = "POST"
}

public enum HTTPStatusCode:Int {
    case success = 200
    case created = 201
    case redirectionError = 301
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    case methodNotImplemented = 501
    case gatewayTimeOut = 503
}

let defaultFatalStatusCodes: [HTTPStatusCode] = [.internalServerError]
public typealias HTTPParameters = [String: Any]

class GitService: NSObject {
    
    static let shared: GitService = {
        
        var instance = GitService()
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 20
        urlconfig.timeoutIntervalForResource = 60
        instance.urlSession = Foundation.URLSession(configuration: urlconfig, delegate: nil, delegateQueue: OperationQueue.main)
        
        return instance
    }()
    
    var urlSession: URLSession!
    
    // MARK: Public
    public func requestWith(method: HTTPMethod, parameters: HTTPParameters?, queryParam: HTTPParameters? = nil, retryCount:Int, showHud: Bool, fatalStatusCodes: [HTTPStatusCode] = defaultFatalStatusCodes, completionHandler: @escaping(Bool, Data?, Error?) -> Void) -> Void {
        
        let request = enqueueRequestWith(method: method, parameters: parameters, queryParam: queryParam)
        
        self.request(request, method: method, parameters: parameters, retryCount: retryCount, showHud: showHud, fatalStatusCodes: fatalStatusCodes, completionHandler: completionHandler)
    }
    
    
    // MARK: Private
    fileprivate func request(_ request: URLRequest, method: HTTPMethod, parameters: HTTPParameters?, retryCount:Int, showHud: Bool, fatalStatusCodes:[HTTPStatusCode], completionHandler: @escaping(Bool, Data?, Error?) -> Void) -> Void {
        
        // Show Hud.
        if showHud {
        }
        
        enqueueDataTaskWith(request: request, retryCount: retryCount, fatalStatusCodes: fatalStatusCodes) { (data, response, error) in
            
            // Hide Hud.
            if showHud {
            }
            
            self.handle(data: data, response: response, error: error, completionHandler: { (success, data, error) in
                completionHandler(success, data, error)
            })
        }
    }
    
    private func enqueueDataTaskWith(request: URLRequest, retryCount:Int, fatalStatusCodes:[HTTPStatusCode], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        
        let task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if let code = HTTPStatusCode(rawValue: httpResponse.statusCode) {
                    
                    // FIXME: More robust condition.
                    if retryCount > 0, !(fatalStatusCodes.contains(code)), code != .success, code != .created {
                        self.enqueueDataTaskWith(request: request, retryCount: retryCount-1, fatalStatusCodes: fatalStatusCodes, completionHandler: completionHandler)
                    }
                    else {
                        completionHandler(data, response, error)
                    }
                }
                else {
                    completionHandler(data, response, error)
                }
            }
            else {
                completionHandler(data, response, error)
            }
        })
        
        task.resume()
    }
    
    private func enqueueUploadTaskWith(request: URLRequest, data:Data, retryCount:Int, fatalStatusCodes:[HTTPStatusCode], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        
        let uploadTask = urlSession.uploadTask(with: request, from: data) { (responseData, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                if let code = HTTPStatusCode(rawValue: httpResponse.statusCode) {
                    
                    // FIXME: More robust condition.
                    if retryCount > 0, !(fatalStatusCodes.contains(code)), code != .success, code != .created {
                        self.enqueueUploadTaskWith(request: request, data: data, retryCount: retryCount-1, fatalStatusCodes: fatalStatusCodes, completionHandler: completionHandler)
                    }
                    else {
                        completionHandler(responseData, response, error)
                    }
                }
                else {
                    completionHandler(responseData, response, error)
                }
            }
        }
        
        uploadTask.resume()
    }
    
    private func handle(data: Data?, response:URLResponse?, error:Error?, completionHandler: @escaping (Bool, Data?, Error?) -> Void) -> Void {
        
        if let httpResponse = response as? HTTPURLResponse {
            
            print("Validating request: \(String(describing: response?.url?.absoluteString)) with HTTP status code: \(httpResponse.statusCode)")
            
            let validated = self.validate(response: httpResponse)
            if !validated {
                completionHandler(false, nil, error)
                return
            }
        }
        
        guard error == nil else {
            completionHandler(false, nil, error)
            return
        }
        
        guard let data = data else {
            completionHandler(false, nil, nil)
            return
        }
        
        do {
            
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                
                print(json)
                
                if let errors = json["error"] as? [[String: Any]] {
                    
                    if errors.count > 0 {
                        if let errorMessage = errors[0]["message"] as? String {
                            let responseError = NSError.errorWith(code: 0, localizedDescription: errorMessage)
                            completionHandler(false, nil, responseError)
                        }
                    }
                }else {
                    completionHandler(true, data, nil)
                }
            }
            
        } catch let error {
            completionHandler(false, nil, error)
        }
    }
    
    // MARK: URLRequest
    fileprivate func enqueueRequestWith(method: HTTPMethod, parameters: HTTPParameters?, queryParam: HTTPParameters? = nil) -> URLRequest {
        
        var urlString = BaseURL
        urlString = encode(url: urlString)
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        
        switch method {
        case .post:
            if let data = JSONEncode(url: url, parameters: parameters) {
                request.httpBody = data
            }
            
        default:
            if let data = JSONEncode(url: url, parameters: parameters) {
                request.httpBody = data
            }
        }
        
        return request
    }
    
    // MARK: Encoding
    private func encode(url: String) -> String {
        return url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    private func JSONEncode(url: URL, parameters: HTTPParameters?) -> Data? {
        
        guard parameters != nil else {
            return nil
        }
        
        guard !parameters!.isEmpty else {
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            return data
        } catch {
            return nil
        }
    }
    
    // MARK: Validate
    private func validate(response: HTTPURLResponse) -> Bool {
        
        if let code = HTTPStatusCode(rawValue: response.statusCode) {
            switch code {
            case .success, .created:
                if let contentType = response.allHeaderFields["Content-Type"] as? String, contentType.contains("application/json") {
                    return true
                }
                
            default:
                return false
            }
        }
        
        return false
    }
}

extension NSNumber {
    fileprivate var isBoolean: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

extension NSError {
    static func errorWith(code: Int, localizedDescription: String?) -> NSError {
        return NSError(domain:"com.neuron.Fasla", code:code, userInfo:[NSLocalizedDescriptionKey: localizedDescription != nil ? localizedDescription! : ""])
    }
}



