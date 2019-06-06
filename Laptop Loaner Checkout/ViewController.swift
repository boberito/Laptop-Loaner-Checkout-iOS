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

//var computerList = [computerObject]()

class computerObject {
    var name: String
    var id: Int
    var DateReturned: String
    var DateOut: String
    var Availability: String
    var Username: String
    var Department: String
    
    init(name: String, id: Int, DateReturned: String, DateOut: String, Availability: String, Username: String, Department: String) {
        self.name = name
        self.id = id
        self.DateReturned = DateReturned
        self.DateOut = DateOut
        self.Availability = Availability
        self.Username = Username
        self.Department = Department
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet var tableView: UITableView!
    var VCcomputerList = [computerObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //getJamfData(url: "\(jamfURL)JSSResource/advancedcomputersearches/id/\(acsID)")
        VCcomputerList = getLocalJamfData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VCcomputerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loanerCell") as! myTableViewCell
        //cell?.textLabel?.text = VCcomputerList[indexPath.row].name
        cell.nameLabel.text = VCcomputerList[indexPath.row].name
        cell.availabilityLabel.text = VCcomputerList[indexPath.row].Availability
        return cell
    }
    
    
}

