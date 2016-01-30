//
//  DateUtils.swift
//  TAPS
//
//  Created by Suhendra Ahmad on 5/9/15.
//  Copyright (c) 2015 azaSoftware. All rights reserved.
//

import UIKit

class DateUtils: NSObject {

    class var dateFormatter: NSDateFormatter {
        
        struct Singleton {
            static var token: dispatch_once_t = 0
            static var dateFormatter: NSDateFormatter! = nil
        }
        
        dispatch_once(&Singleton.token) {
            Singleton.dateFormatter = NSDateFormatter()
        }
        
        return Singleton.dateFormatter
    }

   
    // MARK: - Get String
    
    class func stringFromDate(date: NSDate) -> String {
        return DateUtils.stringFromDate(date, format: "ddMMyyyy")
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        
        DateUtils.dateFormatter.dateFormat = format
        DateUtils.dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
        
        return DateUtils.dateFormatter.stringFromDate(date)
    }
    
    class func stringFromDate(date: NSDate, format: String, timeZone: NSTimeZone!) -> String {
        DateUtils.dateFormatter.dateFormat = format
        DateUtils.dateFormatter.timeZone = timeZone
        
        return DateUtils.dateFormatter.stringFromDate(date)
    }
    
    // MARK: - Get Date
    
    class func dateFromMysqlDate(dateStr: String) -> NSDate! {
        
        DateUtils.dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"
        
        DateUtils.dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        if let _date = DateUtils.dateFormatter.dateFromString(dateStr) {
            return _date
        }
        
        return NSDate()
    }
    
    class func dateFromString(dateStr: String, format: String) -> NSDate! {
        
        DateUtils.dateFormatter.dateFormat = format
        DateUtils.dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
        
        return DateUtils.dateFormatter.dateFromString(dateStr)
    }
    
    class func dateFromString(dateStr: String, format: String, timeZone: NSTimeZone!) -> NSDate! {
        
        DateUtils.dateFormatter.dateFormat = format
        DateUtils.dateFormatter.timeZone = timeZone
        
        return DateUtils.dateFormatter.dateFromString(dateStr)
    }
    
    // MARK: - Components
    
    class func getMonthYearFromDate(date: NSDate) -> (Int, Int) {
        let components = NSCalendar.currentCalendar().components([NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
        let month = components.month
        let year = components.year
        return (month, year)
    }
    
    class func getDayMonthFromDate(date: NSDate) -> (Int, Int) {
        let components = NSCalendar.currentCalendar().components([NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        let month = components.month
        let day = components.day
        return (day, month)
    }
}
