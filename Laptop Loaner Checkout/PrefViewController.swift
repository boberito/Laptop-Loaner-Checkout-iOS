//
//  PrefViewController.swift
//  Laptop Loaner Checkout
//
//  Created by Bob Gendler on 6/10/19.
//  Copyright © 2019 TrueTalentIncorportated. All rights reserved.
//

import UIKit

class PrefViewController: UIViewController, UITextFieldDelegate {
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        availabilityEATextField.delegate = self
        checkOutEATextField.delegate = self
        checkInEATextField.delegate = self
        acsIDTextField.delegate = self
        jamfProURLTextField.delegate = self
        jamfUserTextField.delegate = self
        
        
        availabilityEATextField.text = defaults.string(forKey: "availabilityID") ?? ""
        checkOutEATextField.text = defaults.string(forKey: "checkOutID") ?? ""
        checkInEATextField.text = defaults.string(forKey: "checkInID") ?? ""
        acsIDTextField.text = defaults.string(forKey: "ACSID") ?? ""
        jamfProURLTextField.text = defaults.string(forKey: "jss_URL") ?? ""
        jamfUserTextField.text = defaults.string(forKey: "jamf_username") ?? ""
        
        if let str = KeychainService.loadPassword(service: defaults.string(forKey: "jss_URL") ?? "", account: defaults.string(forKey: "jamf_username") ?? ""
            ) {
            jamfPasswordTextField.text = str
        }
        else {jamfPasswordTextField.text = nil }
        
        
        
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var jamfProURLTextField: UITextField!
    @IBOutlet var jamfUserTextField: UITextField!
    @IBOutlet var jamfPasswordTextField: UITextField!
    @IBOutlet var acsIDTextField: UITextField!
    @IBOutlet var checkInEATextField: UITextField!
    @IBOutlet var checkOutEATextField: UITextField!
    @IBOutlet var availabilityEATextField: UITextField!
    
    func saveClose() {
        if jamfProURLTextField.text != nil || jamfProURLTextField.text != nil || jamfUserTextField.text != nil {
            KeychainService.savePassword(service: jamfProURLTextField.text!, account: jamfUserTextField.text!, data: jamfPasswordTextField.text!)
        }
        
        defaults.set(availabilityEATextField.text, forKey: "availabilityID")
        defaults.set(checkOutEATextField.text, forKey: "checkOutID")
        defaults.set(checkInEATextField.text, forKey: "checkInID")
        defaults.set(acsIDTextField.text, forKey: "ACSID")
        defaults.set(jamfProURLTextField.text, forKey: "jss_URL")
        defaults.set(jamfUserTextField.text, forKey: "jamf_username")
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        saveClose()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if jamfProURLTextField.isFirstResponder {
            jamfUserTextField.becomeFirstResponder()
        } else if jamfUserTextField.isFirstResponder {
            jamfPasswordTextField.becomeFirstResponder()
        } else if jamfPasswordTextField.isFirstResponder {
            acsIDTextField.becomeFirstResponder()
        } else if acsIDTextField.isFirstResponder {
            checkInEATextField.becomeFirstResponder()
        } else if checkInEATextField.isFirstResponder {
            checkOutEATextField.becomeFirstResponder()
        } else if checkOutEATextField.isFirstResponder {
            availabilityEATextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            saveClose()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, up: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, up: false)
    }
    
    func moveTextField(_ textField: UITextField, up: Bool) {
        if UIDevice.modelName.contains("iPhone"){
            if textField.tag > 3 {
                if up {
                    self.scrollView.contentOffset = CGPoint(x:0, y:350)
                }else{
                    self.scrollView.contentOffset = CGPoint(x:0, y:0)
                }
            }
        }
    }
    
}
