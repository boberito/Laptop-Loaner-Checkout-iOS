//
//  computerObject.swift
//  Laptop Loaner Checkout
//
//  Created by Gendler, Bob (Fed) on 6/6/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import Foundation
class computerObject {
    var name: String
    var id: Int
    var DateCheckedIn: String
    var DateCheckedOut: String
    var LoanerAvailability: String
    var Username: String
    var Department: String
    
    init(name: String, id: Int, DateReturned: String, DateOut: String, Availability: String, Username: String, Department: String) {
        self.name = name
        self.id = id
        self.DateCheckedIn = DateReturned
        self.DateCheckedOut = DateOut
        self.LoanerAvailability = Availability
        self.Username = Username
        self.Department = Department
    }
    
}
