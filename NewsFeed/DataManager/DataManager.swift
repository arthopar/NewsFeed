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
    
    static private func fetchDataForParameter(params: Router, compilation: @escaping (Data?, Error?) -> Void) {
        var path = "\(DataManager.baseUrl)\(params.path)?api-key=\(DataManager.apiKey)"
        if params.httpMethod == .get {
            path += params.params.queryString
        }

        let url = URL(string: path)!

        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = params.httpMethod.rawValue
        if params.httpMethod == .post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params.params, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            compilation(data, error)
        })
        task.resume()
    }

    public static func fetchNews(params: NewsListParameter, compilation: @escaping (NewsListModel?, Error?) -> Void) {
        fetchDataForParameter(params: params) { json , error in
            var newsListModel: NewsListModel?
            var outputError: Error?

            if let json = json {
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(Response<NewsListModel>.self, from: json)
                    newsListModel = data.response
                } catch {
                    print(error)
                }
            } else {
                outputError = error
            }

            DispatchQueue.main.async {
                compilation(newsListModel, outputError)
            }
        }
    }
}

struct Response<T: Codable>: Codable {
    let response: T
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for key in self.keys {
            if let value = self[key] {
                output += "&\(key)=\(value)"
            }
        }
        return output
    }
}
