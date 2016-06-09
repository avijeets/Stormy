//
//  APIClient.swift
//  Stormy
//
//  Created by Avijeet Sachdev on 6/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

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