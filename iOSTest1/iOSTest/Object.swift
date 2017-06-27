//
//  Object.swift
//  iOSTest
//
//  Created by Yulminator on 6/14/17.
//  Copyright © 2017 YuraPetrov. All rights reserved.
//

import UIKit
import GoogleMaps

struct Object {
    let id: String
    let title: String
    let description: String
    let image: UIImage
    let location: CLLocationCoordinate2D
    var selected: Bool
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String: Any]) throws {
        
        guard let id = json["ObjectId"] as? String else { throw SerializationError.missing("ObjectId is missing") }
        guard let title = json["Title"] as? String else { throw SerializationError.missing("Title is missing") }
        guard let description = json["Description"] as? String else { throw SerializationError.missing("Description is missing") }
        guard let imageUrl = json["ImageUrl"] as? String else { throw SerializationError.missing("ImageUrl is missing") }
        guard let latitude = json["Latitude"] as? Float else { throw SerializationError.missing("Latitude is missing") }
        guard let longitude = json["longitude"] as? Float else { throw SerializationError.missing("longitude is missing") }
        
        self.id = id
        self.title = title
        self.description = description
        self.location = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        let url = URL(string: imageUrl)
        let data = try? Data(contentsOf: url!)
        self.image = UIImage(data: data!)!
        selected = false
    }
    
    static let basePath = "http://zavtrakov.eurodir.ru/response.json"
    
    static func Places(completion: @escaping ([Object]) -> ()) {
        let request = URLRequest(url: URL(string: basePath)! )
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            var placesArray: [Object] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let status = json["Status"] as? Int, let resultPlaces = json["Result"] as? [[String: Any]] {
                            if status == 200 {
                                for places in resultPlaces {
                                    if let placeObject = try? Object(json: places) {
                                        placesArray.append(placeObject)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(placesArray)
            }
        }
        
        task.resume()
    }
}
