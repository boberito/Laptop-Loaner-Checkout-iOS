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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet var tableView: UITableView!
    
    let apiCalls = JamfCalls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        apiCalls.getLocalJamfData()
        
        //apiCalls.getJamfData(url: "\(jamfURL)JSSResource/advancedcomputersearches/id/\(acsID)")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
    }
 

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiCalls.computerList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loanerCell") as! myTableViewCell
        
        cell.nameLabel.text = apiCalls.computerList[indexPath.row].name
        cell.userNameLabel.text = apiCalls.computerList[indexPath.row].Username
        
        if apiCalls.computerList[indexPath.row].Availability == "No" {
            cell.dotImage.image = UIImage(named: "reddot")
            cell.dateOutLabel.text = "Checked Out: \(apiCalls.computerList[indexPath.row].DateOut)"
            
        } else {
            cell.dotImage.image = UIImage(named: "greendot")
            cell.dateOutLabel.text = "Checked In: \(apiCalls.computerList[indexPath.row].DateReturned)"
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let changeStatus = UIContextualAction(style: .normal, title: "Check Out") { (action, view, nil) in
                if self.apiCalls.computerList[indexPath.row].Availability == "No" {
                    print("Checked In")
                } else {
                    print("Checked Out")
                }
                
            }
            changeStatus.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
            if apiCalls.computerList[indexPath.row].Availability == "No" {
                changeStatus.title = "Check In"
                changeStatus.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                
            }
        
        let config = UISwipeActionsConfiguration(actions: [changeStatus])
        config.performsFirstActionWithFullSwipe = false
        return config
        }
        //return UISwipeActionsConfiguration(actions: changeStatus)
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let changeStatus = UIContextualAction(style: .normal, title: "Check Out") { (action, view, nil) in
            if self.apiCalls.computerList[indexPath.row].Availability == "No" {
                print("Checked In")
            } else {
                print("Checked Out")
            }
        }
        changeStatus.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        if apiCalls.computerList[indexPath.row].Availability == "No" {
            changeStatus.title = "Check In"
            changeStatus.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            
        }
        
        let config = UISwipeActionsConfiguration(actions: [changeStatus])
        config.performsFirstActionWithFullSwipe = false
        return config
        
    }
    
}

