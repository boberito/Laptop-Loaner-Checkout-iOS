//
//  JamfCalls.swift
//  Laptop Loaner Checkout
//
//  Created by Gendler, Bob (Fed) on 6/6/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import Foundation

class JamfCalls {
    var computerList = [computerObject]()
    

    func getLocalJamfData() {
        guard let path = Bundle.main.path(forResource: "advancedsearch", ofType: "json") else { return }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let decoder = JSONDecoder()
        let computerData = try! decoder.decode(advancedSearch.self, from: data)
        //print(computerData)
        for entries in computerData.advanced_computer_search.computers {
            computerList.append(computerObject(name: entries.name, id: entries.id, DateReturned: entries.DateReturned, DateOut: entries.DateOut, Availability: entries.Availability, Username: entries.Username, Department: entries.Department))
            
        }
        
        
    }
    
    func getJamfData(url: String){
        let loginData = "\(jamfUser):\(jamfPassword)".data(using: String.Encoding.utf8)
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
                    //self.errorOccured(typeOfError: "An Error Occured")
                }
            } else {
                do {
                    switch httpResponse!.statusCode {
                    case 401:
                        DispatchQueue.main.async {
                            //self.errorOccured(typeOfError: "Login Error")
                        }
    
                    case 400:
                        DispatchQueue.main.async {
                            //self.errorOccured(typeOfError: "Bad Request")
                        }
                    case 404:
                        DispatchQueue.main.async {
                           // self.errorOccured(typeOfError: "404, something not found")
                        }
    
                    case 200:
                        self.computerList.removeAll()
                        print("Success!")
                        let decoder = JSONDecoder()
                        let computerData = try decoder.decode(advancedSearch.self, from: dataReturn!)
    
                        for entries in computerData.advanced_computer_search.computers {
                            self.computerList.append(computerObject(name: entries.name, id: entries.id, DateReturned: entries.DateReturned, DateOut: entries.DateOut, Availability: entries.Availability, Username: entries.Username, Department: entries.Department))
    
                        }
                        DispatchQueue.main.async {
                            //self.tableView.reloadData()
                        }
                    default:
                        DispatchQueue.main.async {
                            //self.errorOccured(typeOfError: "Unknown Error Occured")
                        }
                    }
    
    
                } catch {
                    DispatchQueue.main.async {
                        //self.errorOccured(typeOfError: "An Unknown Error Occured. I must quit now. Goodbye!")
    
                    }
                }
            }
        }
        task.resume()
    }
    
}
