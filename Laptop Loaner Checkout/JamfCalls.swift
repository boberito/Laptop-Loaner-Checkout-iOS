//
//  JamfCalls.swift
//  Laptop Loaner Checkout
//
//  Created by Gendler, Bob (Fed) on 6/6/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import Foundation


protocol DataModelDelegate: class {
    func didRecieveDataUpdate(data: [computerObject], statusCode: Int)
}

class JamfCalls {
    var computerList = [computerObject]()
    
    weak var delegate: DataModelDelegate?
    
    func getJamfData(url: String){
        
        let defaults = UserDefaults.standard
        if let jamfPassword = KeychainService.loadPassword(service: defaults.string(forKey: "jss_URL")!, account: defaults.string(forKey: "jamf_username")!) {
            
        
        
        let loginData = "\(defaults.string(forKey: "jamf_username")!):\(jamfPassword)".data(using: String.Encoding.utf8)
        let base64LoginString = loginData!.base64EncodedString()
        let headers = ["Accept": "application/json",
                       "Authorization": "Basic \(String(describing: base64LoginString))"]
    
    
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
            
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let sessionDelegate = SessionDelegate()
        let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: OperationQueue.main)
    
        let task = session.dataTask(with: request as URLRequest) {data,response,error in
            let httpResponse = response as? HTTPURLResponse
            let dataReturn = data
            
            if (error != nil) {
                DispatchQueue.main.async {
                    
                    print("An Error Occured")
                }
            } else {
                do {
                    if httpResponse!.statusCode == 200 {
                        self.computerList.removeAll()
                        
                        let decoder = JSONDecoder()
                        let computerData = try decoder.decode(advancedSearch.self, from: dataReturn!)
                        
                        for entries in computerData.advanced_computer_search.computers {
                            self.computerList.append(computerObject(name: entries.name, id: entries.id, DateReturned: entries.DateCheckedIn, DateOut: entries.DateCheckedOut, Availability: entries.LoanerAvailability, Username: entries.Username, Department: entries.Department))
                            
                        }
                        
                        DispatchQueue.main.async {
                            //self.tableView.reloadData()
                            self.delegate?.didRecieveDataUpdate(data: self.computerList, statusCode: httpResponse!.statusCode )
                            
                        }

                    } else {
                        self.delegate?.didRecieveDataUpdate(data: self.computerList, statusCode: httpResponse!.statusCode )
                    }
                    
                    
                } catch {
                    
                    DispatchQueue.main.async {
                        print("An Unknown Error Occured. I must quit now. Goodbye!")
    
                    }
                }
            }
        }
        task.resume()
        }
        
    
    }
    
    
    func putJamfData(jamfID: Int, date: String, availability: String, username: String) {

        var xmldata: String
        let defaults = UserDefaults.standard
        if let jamfPassword = KeychainService.loadPassword(service: defaults.string(forKey: "jss_URL")!, account: defaults.string(forKey: "jamf_username")!) {
            
            
            
            let loginData = "\(defaults.string(forKey: "jamf_username")!):\(jamfPassword)".data(using: String.Encoding.utf8)
            
        let requestURL = "\(defaults.string(forKey: "jss_URL")!)JSSResource/computers/id/\(jamfID)"
        
        if availability == "Yes" {
            xmldata = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><computer><location><username></username><real_name></real_name><email_address></email_address><department></department></location><extension_attributes><extension_attribute><id>\(defaults.string(forKey: "availabilityID")!)</id><value>" + availability + "</value></extension_attribute><extension_attribute><id>\(defaults.string(forKey: "checkInID")!)</id><value>" + date + "</value></extension_attribute></extension_attributes></computer>"
        } else {
            xmldata = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><computer><location><username>" + username + "</username><real_name></real_name><email_address></email_address><department></department></location><extension_attributes><extension_attribute><id>\(defaults.string(forKey: "availabilityID")!)</id><value>" + availability + "</value></extension_attribute><extension_attribute><id>\(defaults.string(forKey: "checkOutID")!)</id><value>" + date + "</value></extension_attribute></extension_attributes></computer>"
        }
        
        let base64LoginString = loginData!.base64EncodedString()
        let headers = [
            "Content-Type": "text/xml",
            "Authorization": "Basic \(base64LoginString)"
        ]
        let postData = NSData(data: xmldata.data(using: String.Encoding.utf8)!)
        let request = NSMutableURLRequest(url: NSURL(string: requestURL)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers

        
        let sessionDelegate = SessionDelegate()
        let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: OperationQueue.main)

        request.httpBody = postData as Data

        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                
            } else {
                DispatchQueue.main.async {
                self.getJamfData(url: "\(defaults.string(forKey: "jss_URL")!)JSSResource/advancedcomputersearches/id/\(defaults.string(forKey: "ACSID")!)")
                }
             
            }

        })
        
        dataTask.resume()

    }
    }
}
