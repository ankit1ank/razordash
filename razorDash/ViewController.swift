//
//  ViewController.swift
//  razorDash
//
//  Created by Ankit Goel on 03/08/15.
//  Copyright (c) 2015 razor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let timeInterval = 9986400
    var arr: [[String: AnyObject]] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let userPasswordString = "rzp_test_K2AsUEhLAvCUej:CoX0Zrb81Rw7kO2b8PsTu0Ht"
        let userPasswordData = userPasswordString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = userPasswordData!.base64EncodedStringWithOptions(nil)
        let authString = "Basic \(base64EncodedCredential)"
        config.HTTPAdditionalHeaders = ["Authorization" : authString]
        let session = NSURLSession(configuration: config)
        let currentTime = Int(NSDate().timeIntervalSince1970)
        
        let url = NSURL(string: "https://api.razorpay.com/v1/payments/?count=10&skip=0&from=\(currentTime-timeInterval)&to=\(currentTime)")
        let task = session.dataTaskWithURL(url!) {
            (let data, let response, let error) in
            if let httpResponse = response as? NSHTTPURLResponse {
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let json: [String: AnyObject] = jsonParse(dataString! as! String) {
                    if let transaction = json["items"] as? [[String: AnyObject]] {
                        for item in transaction {
                            self.arr.append(item)
                        }
                        dispatch_async(dispatch_get_main_queue()){
                            self.tableView.reloadData()
                        }
                    }
                    else {
                        println("Parsing error")
                    }
                } else {
                    println("Parsing error")
                }
                
            }
        }
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = arr[indexPath.row]["id"] as? String
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let detailViewController = segue.destinationViewController as? DetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let selectedTransaction = arr[indexPath.row]
                detailViewController?.transactionDetails = selectedTransaction
            }
        }
    }

}

