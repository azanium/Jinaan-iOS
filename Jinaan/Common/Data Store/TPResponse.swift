//
//  TPResponse.swift
//  TAPS
//
//  Created by Suhendra Ahmad on 10/24/15.
//  Copyright © 2015 azaSoftware. All rights reserved.
//

import UIKit
import SwiftyJSON

class TPResponse: NSObject {
    
    var status: String = ""
    var message: String = ""
    var error: String = ""
 
    init(json: JSON) {
        super.init()

    }
}
