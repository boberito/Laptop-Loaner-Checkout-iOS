//
//  putData.swift
//  Laptop Loaner Checkout
//
//  Created by Bob Gendler on 5/23/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import Foundation

func putJamfData(jamfID: Int, date: String, availability: String, username: String) {
    var xmldata: String
    
    let requestURL = "\(jamfURL)JSSResource/computers/id/\(jamfID)"
    
    if availability == "Yes" {
        xmldata = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><computer><location><username></username><real_name></real_name><email_address></email_address><department></department></location><extension_attributes><extension_attribute><id>\(availabilityID)</id><value>" + availability + "</value></extension_attribute><extension_attribute><id>\(checkInID)</id><value>" + date + "</value></extension_attribute></extension_attributes></computer>"
    } else {
        xmldata = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><computer><location><username>" + username + "</username><real_name></real_name><email_address></email_address><department></department></location><extension_attributes><extension_attribute><id>\(availabilityID)</id><value>" + availability + "</value></extension_attribute><extension_attribute><id>\(checkOutID)</id><value>" + date + "</value></extension_attribute></extension_attributes></computer>"
    }
    
    let loginData = "\(jamfUser):\(jamfPassword)".data(using: String.Encoding.utf8)
    let base64LoginString = loginData!.base64EncodedString()
    let postData = NSData(data: xmldata.data(using: String.Encoding.utf8)!)
    let headers = ["Content-Type": "text/xml", "Authorization": "Basic \(String(describing: base64LoginString))"]
    let request = NSMutableURLRequest(url: NSURL(string: requestURL)! as URL,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
    request.httpMethod = "PUT"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData as Data
    
    
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        
        dispatchGroup.leave()
    }
    )
    
    dataTask.resume()
    
    dispatchGroup.wait()
    
}
