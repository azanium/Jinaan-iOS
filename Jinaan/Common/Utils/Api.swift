//
//  Api.swift
//  TAPS
//
//  Created by Suhendra Ahmad on 3/5/15.
//  Copyright (c) 2015 azaSoftware. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum ApiErrorType : Int {
    case Silent = 0
    case All = 1
    case Dialog = 2
    case Event = 3
}

protocol ApiErrorDelegate {
    func apiError(error: NSError?, message: String)
}

class Api {

    static var defaultServer: String = ""
    var errorReport: ApiErrorType = .All
    
    struct Response {
        static let Status: String = "status"
        static let Message: String = "message"
        static let Error: String = "error"
    }
    
    struct Status {
        static let OK: String = "OK"
        static let Error: String = "ERROR"
        static let SessionExpired: String = "SESSION_EXPIRED"
        static let Unverified: String = "UNVERIFIED"
    }

    private static var events: [ApiErrorDelegate] = []
    class func addEvent(delegate: ApiErrorDelegate?, purgeAll: Bool = true) {
        if let _delegate = delegate {
            if purgeAll {
                Api.events.removeAll()
            }
            
            Api.events.append(_delegate)
        }
    }
    
    struct Gateway {
        static let Login: String = "user/login"
        static let Logout: String = "user/logout"
        
    }
    
    class func handleError(jsonObj: JSON, error: NSError?) -> Bool {
        if error != nil {
            print("POST ERROR: \(error)")
            
            return false
        }
        else {
            if let status = jsonObj[Api.Response.Status].string {
                if status == Api.Status.SessionExpired {
                    
                    return false
                }
                else if status == Api.Status.Error {
                    
                    return false
                }
            }
        }
        return true
    }
    
    class func handleError(jsonString: String, error: NSError?) -> Bool {
        if error != nil {
            print("POST ERROR: \(error)")
            
            return true
        }
        else {
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json: JSON = JSON(data: data)
                if let status = json[Api.Response.Status].string {
                    if status == Api.Status.Error {
                        
                        return false
                    }
                }
            }
        }
        return true
    }
    
    class func handleError(jsonDict: NSDictionary, error: NSError?) -> Bool {
        if error != nil {
            print("POST ERROR: \(error)")
            
            return true
        }
        else {
            if let status = jsonDict.valueForKey(Api.Response.Status) as? String {
                if status == Api.Status.SessionExpired {
                    
                    return false
                }
                else if status == Api.Status.Error {
                    
                    return false
                }
            }
        }
        return true
    }
    
    private class func broadcastEvent(error: NSError?, message: String) {
        if Api.events.count > 0 {
            for ev in Api.events {
                dispatch_async(dispatch_get_main_queue()) {
                    ev.apiError(error, message: message)
                }
            }
        }
    }
    
    class func renderError(error: NSError?) -> Bool {
        
        return false
    }
    
    class func renderError(jsonString: String, error: NSError?) -> Bool {
        
        return true
    }
    
    
    static var lastStatus: String = ""
    
    class func renderError(jsonDict: NSDictionary, error: NSError?) -> Bool {
        
        return true
    }
    
    class func renderError(jsonObj: JSON, error: NSError?) -> Bool {
        
        return true
    }
    
    class func getServerBase() -> String {
        var url = Api.defaultServer
        if Api.defaultServer != "" {
            url = Api.defaultServer
            Api.defaultServer = ""
        }
        return url
    }
    
    class func getServerURLWithPath(path: String) -> String {
        let url: NSURL = NSURL(string: Api.getServerBase())!.URLByAppendingPathComponent(path)
        
        return url.URLString
    }
    
    class func requestPost(apiPath: String, parameters: [String: AnyObject]! = nil) -> Request {
        let url = NSURL(string: Api.getServerBase())!.URLByAppendingPathComponent(apiPath)
        
        print("::API => Requesting POST : \(url.URLString)\n=> Parameters: \(parameters)")
        
        return request(.POST, url.URLString, parameters: parameters)
    }
    
    class func requestGet(apiPath: String, parameters: [String: AnyObject]! = nil) -> Request {
        let url = NSURL(string: Api.getServerBase())!.URLByAppendingPathComponent(apiPath)
        
        print("::API => Requesting GET : \(url.URLString)\n=> Parameters: \(parameters)")
        
        return request(.GET, url.URLString, parameters: parameters)
    }
    
    class func requestPostString(apiPath: String, parameters: [String: AnyObject]!, completion:((error: NSError?, result: String?)->Void)!) {
        
        Api.requestPost(apiPath, parameters: parameters).responseString { (request, response, result) in
            switch result {
            case .Success(let value):
                
                print("::API (\(apiPath)) => Response: \(value)")
                
                var newError: NSError? = result.error as? NSError
                if !Api.handleError(value, error: newError) {
                    newError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
                }
                
                if completion != nil {
                    completion(error: newError, result: value)
                }
                
                Api.renderError(value, error: result.error as? NSError)
                
            case .Failure(let data, let error):
                let text = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var newError = error as NSError
                if !Api.handleError(text as! String, error: newError) {
                    newError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
                }
                if completion != nil {
                    completion(error: newError, result: "")
                }
                Api.renderError(text as! String, error: error as NSError)
                print("::ERROR: \(error)")
            }
            
        }
    }
    
    class func requestGetString(apiPath: String, parameters: [String: AnyObject]!, completion:((error: NSError?, result: String?)->Void)!) {
        
        Api.requestGet(apiPath, parameters: parameters).responseString { (request, response, result) in
            switch result {
            case .Success(let value):
                
                print("::API (\(apiPath)) => Response: \(value)")

                var newError: NSError? = result.error as? NSError
                if !Api.handleError(value, error: newError) {
                    newError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
                }
                
                if completion != nil {
                    completion(error: newError, result: value)
                }
                
                Api.renderError(value, error: result.error as? NSError)
                
            case .Failure(let data, let error):
                let text = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var newError = error as NSError
                if !Api.handleError(text as! String, error: newError) {
                    newError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
                }
                if completion != nil {
                    completion(error: newError, result: "")
                }
                Api.renderError(text as! String, error: error as NSError)
                print("::ERROR: \(error)")

            }
        }
    }
    
    class func requestPostJson(apiPath: String, parameters: [String: AnyObject]!, completion:((error: NSError?, json: JSON!)->Void)!) {
        
        Api.requestPost(apiPath, parameters: parameters).responseString { (request, response, result) -> Void in
            
            switch result {
            case .Success(let value):
                
                if let dataString = value.dataUsingEncoding(NSUTF8StringEncoding) {
                    let json = JSON(data: dataString)
                
                    print("::API (\(apiPath)) => Response: \(json)")
                    
                    var newError: NSError? = result.error as? NSError
                    if !Api.handleError(json, error: newError) {
                        newError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
                    }

                    if completion != nil {
                        completion(error: newError, json: json)
                    }
                    
                    Api.renderError(json, error: result.error as? NSError)
                }
                
            case .Failure(let data, let error):
                let text = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var newError = error as NSError
                if !Api.handleError(text as! String, error: newError) {
                    newError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
                }
                
                if completion != nil {
                    completion(error: newError, json: nil)
                }
                
                Api.renderError(text as! String, error: error as NSError)
                print("::ERROR: \(error)")
            }
        }
    }
    
    
    class func requestGetJson(apiPath: String, parameters: [String: AnyObject]!, completion:((error: NSError?, json: JSON!)->Void)!) {
        Api.requestGet(apiPath, parameters: parameters).responseString { (request, response, result) -> Void in
            switch result {
            case .Success(let value):
                
                if let dataString = value.dataUsingEncoding(NSUTF8StringEncoding) {
                    let json = JSON(data: dataString)
                    
                    print("::API (\(apiPath)) => Response: \(json)")
                    
                    var newError: NSError? = result.error as? NSError
                    if !Api.handleError(json, error: newError) {
                        newError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
                    }
                    
                    if completion != nil {
                        completion(error: newError, json: json)
                        
                    }
                    
                    Api.renderError(json, error: result.error as? NSError)
                }
                
            case .Failure(let data, let error):
                let text = NSString(data: data!, encoding: NSUTF8StringEncoding)
                var newError = error as NSError
                if !Api.handleError(text as! String, error: newError) {
                    newError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
                }
                if completion != nil {
                    completion(error: newError, json: nil)
                }
                Api.renderError(text as! String, error: error as NSError)
                print("::ERROR: \(error)")

            }
        }
    }
    
    
    class func getAbsoluteUrlPath(path: String) -> String {
        return Api.getServerURLWithPath(path).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    class func getAbsoluteUrl(path: String) -> NSURL? {
        return NSURL(string: getAbsoluteUrlPath(path))
    }
    
    class func getAbsoluteImageUrlPath(path: String) -> String {
        let base = Api.getServerBase()
        
        let absPath = base + path
        return absPath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }

}



