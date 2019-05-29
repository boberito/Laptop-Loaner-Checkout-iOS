//
//  ViewController.swift
//  Laptop Loaner Checkout
//
//  Created by Bob Gendler on 5/19/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import UIKit

var jamfUser = ""
var jamfPassword = ""
var jamfURL = ""
var acsID = "68"
var availabilityID = "69"
var checkInID = "68"
var checkOutID = "67"

class ViewController: UIViewController {
    
    

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getJamfData(url: "\(jamfURL)JSSResource/advancedcomputersearches/id/\(acsID)")
        
    }
    
    

}

extension NSURLRequest {
    #if DEBUG
    static func allowsAnyHTTPSCertificate(forHost host: String) -> Bool {
        return true
    }
    #endif
}


//extension ViewController: UITableViewDelegate {
//    
//}
//
//extension ViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "loanerCell", for: indexPath)
//        return cell
//    }
//}
