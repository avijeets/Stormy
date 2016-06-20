//
//  ForecastClient.swift
//  Stormy
//
//  Created by Avijeet Sachdev on 6/19/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

final class ForecastAPIClient: APIClient {
    let configuration: NSURLSessionConfiguration
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.configuration)
    }()
    
    private let token: String
    
    init(config: NSURLSessionConfiguration, APIKey: String) {
        self.configuration = config
        self.token = APIKey
    }
    
    convenience init(APIKey: String) {
        self.init(config: NSURLSessionConfiguration.defaultSessionConfiguration(), APIKey: APIKey)
    }
}