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
var jamfURL = "/"
var acsID = "68"
var availabilityID = "69"
var checkInID = "68"
var checkOutID = "67"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataModelDelegate  {
    func didRecieveDataUpdate(data: [computerObject]) {
        self.tableView.reloadData()
    }
    

    @IBOutlet var tableView: UITableView!
    
    let apiCalls = JamfCalls()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        apiCalls.delegate = self
    
        //apiCalls.getLocalJamfData()
        
        apiCalls.getJamfData(url: "\(jamfURL)JSSResource/advancedcomputersearches/id/\(acsID)")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd"
            let dateOut = dateFormatter.date(from: apiCalls.computerList[indexPath.row].DateOut)
            
            dateFormatter.dateFormat = "MM-dd-yyy"
            let updateDateString = dateFormatter.string(from: dateOut!)
            
            cell.dateOutLabel.text = "Checked Out: \(updateDateString)"
            
        } else {
            cell.dotImage.image = UIImage(named: "greendot")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd"
            let dateOut = dateFormatter.date(from: apiCalls.computerList[indexPath.row].DateReturned)
        
            dateFormatter.dateFormat = "MM-dd-yyy"
            let updateDateString = dateFormatter.string(from: dateOut!)
            
            cell.dateOutLabel.text = "Checked In: \(updateDateString)"
 
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
            let changeStatus = UIContextualAction(style: .normal, title: "Check Out") { (action, view, nil) in
                if self.apiCalls.computerList[indexPath.row].Availability == "No" {
                    self.checkIn(selected: indexPath.row)
                } else {
                    //
                    self.dialogBox(selected: indexPath.row)
                    
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
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let changeStatus = UIContextualAction(style: .normal, title: "Check Out") { (action, view, nil) in
            if self.apiCalls.computerList[indexPath.row].Availability == "No" {
                self.checkIn(selected: indexPath.row)
            } else {
                self.dialogBox(selected: indexPath.row)
                
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
    
    
    func checkIn(selected: Int) {
        //print("Checked In")
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateIn = formatter.string(from: today)
        
        self.apiCalls.putJamfData(jamfID: self.apiCalls.computerList[selected].id, date: dateIn, availability: "Yes", username: "")
        self.apiCalls.getJamfData(url: "\(jamfURL)JSSResource/advancedcomputersearches/id/\(acsID)")
        self.tableView.reloadData()
    }
    
    
    
    func dialogBox(selected: Int) {
        
        var inputTextField: UITextField?;
        
        let userPrompt = UIAlertController(title: "Enter Username", message: "You have selected to check out a Loaner Laptop.", preferredStyle: UIAlertController.Style.alert);
        
        userPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) -> Void in            
            let entryStr : String = (inputTextField?.text)! ;
            
            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateOut = formatter.string(from: today)
            
            self.apiCalls.putJamfData(jamfID: self.apiCalls.computerList[selected].id, date: dateOut, availability: "No", username: entryStr)
            self.tableView.reloadData()
        }));
        
        
        userPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
        }));
        
        
        userPrompt.addTextField(configurationHandler: {(textField: UITextField!) in
            
            textField.isSecureTextEntry = false
            inputTextField = textField
        });
        
        
        self.present(userPrompt, animated: true, completion: nil);
        
        self.apiCalls.getJamfData(url: "\(jamfURL)JSSResource/advancedcomputersearches/id/\(acsID)")
        self.tableView.reloadData()
        
        return;
    }
}
