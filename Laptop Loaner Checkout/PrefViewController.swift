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
    
    @IBOutlet var jamfProURLTextField: UITextField!
    @IBOutlet var jamfUserTextField: UITextField!
    @IBOutlet var jamfPasswordTextField: UITextField!
    @IBOutlet var acsIDTextField: UITextField!
    @IBOutlet var checkInEATextField: UITextField!
    @IBOutlet var checkOutEATextField: UITextField!
    @IBOutlet var availabilityEATextField: UITextField!
   
    

    
    @IBAction func saveButton(_ sender: Any) {
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Start Editing The Text Field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: true)
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -250, up: false)
    }
    
    // Hide the keyboard when the return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        if textField.tag > 3 {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        }
    }

}
