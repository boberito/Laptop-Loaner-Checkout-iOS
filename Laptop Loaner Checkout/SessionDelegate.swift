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
            print(challenge.protectionSpace.host)
            if(challenge.protectionSpace.host == "***REMOVED***")
            {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
            }
        }

    }
}
