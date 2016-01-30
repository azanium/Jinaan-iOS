//
//  TPRequest.swift
//  TAPS
//
//  Created by Suhendra Ahmad on 10/23/15.
//  Copyright © 2015 azaSoftware. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPRequest<T>: NSObject {
    
    func apiPath() -> String {
        return "/"
    }
    
    func params() -> [String:String] {
        return [:]
    }
    
    func response(json: JSON) -> T? {
        return nil
    }
}
