//
//  SessionDelegate.swift
//  Laptop Loaner Checkout
//
//  Created by Gendler, Bob (Fed) on 6/6/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import Foundation

class SessionDelegate:NSObject, URLSessionDelegate
{
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
        {
            let jamfURL = UserDefaults.standard.string(forKey: "jss_URL") ?? ""
            let start = jamfURL.index(jamfURL.startIndex, offsetBy: 8)
            let end = jamfURL.index(jamfURL.endIndex, offsetBy: -6)
            let range = start..<end
            let shortURL = jamfURL[range]
            
            //print(shortURL)
            if(challenge.protectionSpace.host == shortURL)
            {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            }
        }

    }
}


