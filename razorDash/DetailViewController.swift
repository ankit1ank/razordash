//
//  DetailViewController.swift
//  razorDash
//
//  Created by Ankit Goel on 03/08/15.
//  Copyright (c) 2015 razor. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var label: UILabel!
    var transactionDetails: [String: AnyObject] = [:]
    var id = ""
    var amount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureButton.enabled = false
        captureButton.hidden = true
        label.text = transactionDetails.description
        
        let paymentStatus = transactionDetails["status"] as? String
        if paymentStatus == "authorized" {
            captureButton.enabled = true
            captureButton.hidden = false
            
            id = transactionDetails["id"]! as! String
            amount = transactionDetails["amount"]! as! Int
        }
    }
    
    @IBAction func captureButtonPressed(sender: AnyObject) {
        
        let stringAmount: NSString = "amount=\(amount)"
        
        let baseUrl = "https://api.razorpay.com/v1/payments/",
        params = "\(id)/capture",
        requestUrl = NSURL(string: "\(baseUrl)\(params)"),
        request = NSMutableURLRequest(URL:requestUrl!)
        request.HTTPMethod = "POST";
        request.HTTPBody = stringAmount.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Create session configuration (for authentication)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration(),
        userPasswordString = "rzp_test_K2AsUEhLAvCUej:CoX0Zrb81Rw7kO2b8PsTu0Ht",
        userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding),
        base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(nil),
        authString = "Basic \(base64EncodedCredential)"
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        
        // Create session
        let session = NSURLSession(configuration: config)
        
        // Set up task for execution
        let task = session.dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                println("error=\(error)")
                return
            }
            
            let dataString = (NSString(data: data, encoding: NSUTF8StringEncoding)!) as! String
            if let jsonData: [String: AnyObject] = jsonParse(dataString),
            let status = jsonData["status"] as? String {
                
                if status == "captured" {
                    println("Successfully captured the transaction")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println("Something went wrong, try capturing later.")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            
        }
        
        task.resume()
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
