//
//  Ser.swift
//  iOSTestForSiteDevel
//
//  Created by Yulminator on 6/24/17.
//  Copyright © 2017 YuraPetrov. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
