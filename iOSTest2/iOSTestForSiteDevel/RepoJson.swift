//
//  RepoJson.swift
//  iOSTestForSiteDevel
//
//  Created by Yulminator on 6/24/17.
//  Copyright © 2017 YuraPetrov. All rights reserved.
//

import Foundation

struct RepoJson {
    var full_name: String
    var html_url: String
    
    init(json: [String: Any]) throws {
        guard let full_name = json["full_name"] as? String else { throw SerializationError.missing("full_name is missing") }
        guard let html_url = json["html_url"] as? String else { throw SerializationError.missing("html_url is missing") }
        
        self.full_name = full_name
        self.html_url = html_url
    }
    
    static func get(url: String, completion: @escaping (RepoJson!) -> ()) {
        let request = URLRequest(url: URL(string: url + "?client_id=1baa3e02c4155c68f787&client_secret=7b565ff127f52b86fc9cc4c2bf30715b414e9121")!)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var repo: RepoJson!
            if let data = data {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let r = try? RepoJson(json: jsonArray) {
                            repo = r
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(repo)
            }
        }
        task.resume()
    }
}
