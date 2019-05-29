//
//  jamfData.swift
//  Laptop Loaner Checkout
//
//  Created by Bob Gendler on 5/23/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import Foundation

struct advancedSearch: Decodable {
    let advanced_computer_search: acs
    
    struct acs: Decodable {
        let computers: [computers]
        
        struct computers: Decodable {
            let name: String
            let id: Int
            let DateReturned: String
            let DateOut: String
            let Availability: String
            let Username: String
            let Department: String
        }
    }
}
