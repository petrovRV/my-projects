//
//  Actor.swift
//  iOSTestForSiteDevel
//
//  Created by Yulminator on 6/21/17.
//  Copyright © 2017 YuraPetrov. All rights reserved.
//

import Foundation
import UIKit

class UsersJson {
    var title = ""
    var description = ""
    var url = ""
    let avatar: UIImage!
    
    init(json: [String: Any]) throws {
        guard let type = json["type"] as? String else { throw SerializationError.missing("type is missing") }
        guard let created_at = json["created_at"] as? String else { throw SerializationError.missing("created_at is missing") }
        guard let actor = json["actor"] as? [String: Any] else {throw SerializationError.missing("actor is missing") }
        guard let rep = json["repo"] as? [String: Any] else {throw SerializationError.missing("actor is missing") }
        
        if let url = URL(string: actor["avatar_url"] as! String) {
            let data = try? Data(contentsOf: url)
            self.avatar = UIImage(data: data!) ?? nil
        } else {
            self.avatar = nil
        }
        
        RepoJson.get(url: rep["url"] as! String) { (results:RepoJson?) in
            if let repo = results, let title =  actor["display_login"] as? String  {
                self.title = "\(title) - \(repo.full_name)"
                self.description = "\(type) \(created_at)"
                self.url = "\(repo.html_url)"
            }
        }
    }
    
    static let basePath = "https://api.github.com/events?client_id=1baa3e02c4155c68f787&client_secret=7b565ff127f52b86fc9cc4c2bf30715b414e9121"
    
    static func get(completion: @escaping ([UsersJson]) -> ()) {
        let request = URLRequest(url: URL(string: basePath)!)
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var usersArray: [UsersJson] = []
            if let data = data {
                do {
                    if let jsonAny = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        if let jsonMatrix = jsonAny as? [[String: Any]] {
                            for jsonArray in jsonMatrix {
                                if let user = try? UsersJson(json: jsonArray) {
                                    usersArray.append(user)
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(usersArray)
            }
        }
        task.resume()
    }
}
