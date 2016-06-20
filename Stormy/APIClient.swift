//
//  APIClient.swift
//  Stormy
//
//  Created by Avijeet Sachdev on 6/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

public let TRENetworkingErrorDomain = "com.avijeets.Stormy.NetworkingError"
public let MissingHTTPResponseError = 10

typealias JSON = [String : AnyObject]
typealias JSONTaskCompletion = (JSON?, NSHTTPURLResponse?, NSError?) -> Void
typealias JSONTask = NSURLSessionDataTask

enum APIResult {
    case Success(CurrentWeather)
    case Failure(ErrorType)
}

protocol APIClient {
    var configuration: NSURLSessionConfiguration { get }
    var session: NSURLSession { get }
    
    init(config: NSURLSessionConfiguration)
    
    func JSONTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask
    func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult -> Void)
}

extension APIClient {
    func JSONTaskWithRequest(request: NSURLRequest, completion: JSONTaskCompletion) -> JSONTask {
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard let HTTPResponse = response as? NSHTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                
                let error = NSError(domain: TRENetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, HTTPResponse, error)
                }
            }
            else {
                switch HTTPResponse.statusCode {
                    case 200:
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String : AnyObject]
                            completion(json, HTTPResponse, nil)
                        } catch let error as NSError {
                            completion(nil, HTTPResponse, error)
                    }
                default: print ("Received HTTP Response: \(HTTPResponse.statusCode) - not handled")
                }
            }
        }
        
        return task
    }
    func fetch<T>(request: NSURLRequest, parse: JSON -> T?, completion: APIResult -> Void) {
        let task = JSONTaskWithRequest(request) { json, response, error in
            guard let json = json else {
                if let error = error {
                    completion(.Failure(error))
                }
                else {
                    // TODO: Implement Error Handling
                }
                return
            }
        }
        task.resume()
    }
}