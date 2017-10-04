//
//  DataManager.swift
//  NewsFeed
//
//  Created by Artak Tsatinyan on 10/4/17.
//  Copyright © 2017 Artak Tsatinyan. All rights reserved.
//

import Foundation

class DataManager {
    private static let apiKey = "test"
    private static let baseUrl = "https://content.guardianapis.com/"
    
    public func fetchDataForParameter(params: Router) {
        let url = URL(string: "\(DataManager.baseUrl)\(params.path)?api-key=\(DataManager.apiKey)")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = params.httpMethod
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params.params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
