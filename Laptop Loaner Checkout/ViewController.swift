//
//  ViewController.swift
//  Laptop Loaner Checkout
//
//  Created by Bob Gendler on 5/19/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import UIKit
import SystemConfiguration


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataModelDelegate  {
    
    var jamfUser: String?
    var jamfURL: String?
    var acsID: String?
    var availabilityID: String?
    var checkInID: String?
    var checkOutID: String?
    var settingsNeeded: Bool?
    let defaults = UserDefaults.standard
    
    var statusBarOrientation: UIInterfaceOrientation? {
        get {
            guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
                #if DEBUG
                fatalError("Could not obtain UIInterfaceOrientation from a valid windowScene")
                #else
                return nil
                #endif
            }
            return orientation
        }
    }
    
    
    func didRecieveDataUpdate(data: [computerObject], statusCode: Int) {
        switch statusCode{
        case 401:
            error(title: "Login Incorrect", message: "Bad username and Password.")
        case 400:
            error(title: "Bad Request", message: "The request you sent to the server was somehow incorrect or corrupted and the server couldn't understand it.")
        case 404:
            error(title: "Not Found", message: "404, something not found.")
        case 200:
            self.tableView.reloadData()
            
        default:
            error(title: "Error!", message: "Something went wrong.")
        }
        
        
    }
    
    @IBAction func reloadButton(_ sender: Any){
        reload()
        
    }
    
    @IBOutlet var tableView: UITableView!
    
    
    let apiCalls = JamfCalls()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.becomeFirstResponder()
        
        apiCalls.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        if defaults.string(forKey: "availabilityID") != nil || defaults.string(forKey: "checkOutID") != nil || defaults.string(forKey: "checkInID") != nil || defaults.string(forKey: "ACSID") != nil || defaults.string(forKey: "jss_URL") != nil || defaults.string(forKey: "jamf_username") != nil {
            
            jamfUser = defaults.string(forKey: "jamf_username") ?? ""
            jamfURL = defaults.string(forKey: "jss_URL") ?? ""
            acsID = defaults.string(forKey: "ACSID") ?? ""
            availabilityID = defaults.string(forKey: "availabilityID") ?? ""
            checkInID = defaults.string(forKey: "checkInID") ?? ""
            checkOutID = defaults.string(forKey: "checkOutID")  ?? ""
            if jamfUser == "" {
                jamfUser = " "
            }
            if KeychainService.loadPassword(service: jamfURL!, account: jamfUser!) != nil {
                apiCalls.getJamfData(url: "\(jamfURL!)JSSResource/advancedcomputersearches/id/\(acsID!)")
                
                tableView.reloadData()
            } else {
                
                settingsNeeded = true
            }
        } else {
            
            settingsNeeded = true
            
        }
        
    }
    
    func reload() {
        if defaults.string(forKey: "availabilityID") != nil || defaults.string(forKey: "checkOutID") != nil || defaults.string(forKey: "checkInID") != nil || defaults.string(forKey: "ACSID") != nil || defaults.string(forKey: "jss_URL") != nil || defaults.string(forKey: "jamf_username") != nil {
            
            jamfUser = defaults.string(forKey: "jamf_username") ?? ""
            jamfURL = defaults.string(forKey: "jss_URL") ?? ""
            acsID = defaults.string(forKey: "ACSID") ?? ""
            availabilityID = defaults.string(forKey: "availabilityID") ?? ""
            checkInID = defaults.string(forKey: "checkInID") ?? ""
            checkOutID = defaults.string(forKey: "checkOutID")  ?? ""
        }
        
        apiCalls.getJamfData(url: "\(jamfURL!)JSSResource/advancedcomputersearches/id/\(acsID!)")
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if settingsNeeded == true {
            settingsNeeded = false
            performSegue(withIdentifier: "prefSegue", sender: self)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            reload()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiCalls.computerList.count
        
    }
    
    #if !targetEnvironment(macCatalyst)
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.tableView.reloadData()
        })
    }
    #endif
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loanerCell") as! myTableViewCell
        
        #if targetEnvironment(macCatalyst)
            cell.actionButton.isHidden = false
        #else
            cell.actionButton.isHidden = true
        #endif
        
        cell.actionButton.tag = indexPath.row
        
        let orientation = statusBarOrientation?.isLandscape ?? false
        
        if UIDevice.modelName.contains("iPhone") && !orientation {
        //if UIDevice.modelName.contains("iPhone") && !UIApplication.shared.statusBarOrientation.isLandscape {
            if apiCalls.computerList[indexPath.row].name.count > 16 {
                let numToCut = -1 * (apiCalls.computerList[indexPath.row].name.count - 16)
                let endIndex = apiCalls.computerList[indexPath.row].name.index(apiCalls.computerList[indexPath.row].name.endIndex, offsetBy: numToCut)
                let truncated = apiCalls.computerList[indexPath.row].name.substring(to: endIndex)
                cell.nameLabel.text = "\(truncated)..."
            } else {
                cell.nameLabel.text = apiCalls.computerList[indexPath.row].name
            }
    
        } else {
            cell.nameLabel.text = apiCalls.computerList[indexPath.row].name
        }
        cell.userNameLabel.text = apiCalls.computerList[indexPath.row].Username
        
        if apiCalls.computerList[indexPath.row].Availability == "No" {
            cell.dotImage.image = UIImage(named: "reddot")
            cell.actionButton.setImage(UIImage(named: "reddot"), for: .normal)
            cell.actionButton.setTitle("Red!", for: .normal)
            cell.actionButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd"
            let dateOut = dateFormatter.date(from: apiCalls.computerList[indexPath.row].DateOut)
            
            dateFormatter.dateFormat = "MM-dd-yyy"
            if dateOut != nil {
                let updateDateString = dateFormatter.string(from: dateOut!)
                
                cell.dateOutLabel.text = "Checked Out: \(updateDateString)"
            } else {
                cell.dateOutLabel.text = "Checked Out:"
            }
        } else {
            cell.dotImage.image = UIImage(named: "greendot")
            cell.actionButton.setTitle("Green!", for: .normal)
            cell.actionButton.setImage(UIImage(named: "greendot"), for: .normal)
            cell.actionButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "yyyy-MM-dd"
            let dateOut = dateFormatter.date(from: apiCalls.computerList[indexPath.row].DateReturned)
            
            dateFormatter.dateFormat = "MM-dd-yyy"
            if dateOut != nil {
                let updateDateString = dateFormatter.string(from: dateOut!)
                
                cell.dateOutLabel.text = "Checked In: \(updateDateString)"
            } else {
                cell.dateOutLabel.text = "Checked In:"
            }
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
    
    @IBAction func actionButton(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "reddot") {
            checkIn(selected: sender.tag)
        }else {
            dialogBox(selected: sender.tag)
        }
        reload()
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
        self.apiCalls.getJamfData(url: "\(jamfURL!)JSSResource/advancedcomputersearches/id/\(acsID!)")
        self.tableView.reloadData()
    }
    
    func error(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
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
        
        self.apiCalls.getJamfData(url: "\(jamfURL!)JSSResource/advancedcomputersearches/id/\(acsID!)")
        
        self.tableView.reloadData()
        
        return;
    }
}
