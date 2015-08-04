//
//  HTTPRequest.swift
//  razorDash
//
//  Created by Ankit Goel on 03/08/15.
//  Copyright (c) 2015 razor. All rights reserved.
//

import Foundation

public struct HTTPRequest {
    
    static func HTTPGet(url: String, callback: (String, String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!) //To get the URL of the receiver , var URL: NSURL? is used
        HTTPsendRequest(request, callback: callback)
    }
    
    static func HTTPPostJSON(url: String, content: String, callback: (String, String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        let jsonString = content
        let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        request.HTTPBody = data
        HTTPsendRequest(request,callback: callback)
    }
    
    static func HTTPsendRequest(request: NSMutableURLRequest,callback: (String, String?) -> Void) {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler :
            {
                data, response, error in
                if error != nil {
                    callback("", (error!.localizedDescription) as String)
                } else {
                    callback(NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,nil)
                }
        })
        
        task.resume() //Tasks are called with .resume()
        
    }
    
    static func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value){
            if let data = NSJSONSerialization.dataWithJSONObject(value,options: options, error:nil){
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding){
                    return string as String
                }
            }
        }
        return ""
    }
}
