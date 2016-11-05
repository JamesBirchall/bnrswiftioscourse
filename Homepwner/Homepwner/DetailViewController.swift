//
//  DetailViewController.swift
//  Homepwner
//
//  Created by James Birchall on 31/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var serialInputField: UITextField!
    @IBOutlet weak var valueInputField: UITextField!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameInputField.text = item.name
        serialInputField.text = item.serialNumber
//        valueInputField.text = "\(item.valueInDollars)"
//        dateCreatedLabel.text = "\(item.dateCreated)"
        
        valueInputField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateCreatedLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // end editing if tapped back before clicking elsewhere
        
        // save items on way out if valid else don't
        item.name = nameInputField.text ?? ""    // not valid return empty string
        item.serialNumber = serialInputField.text ?? ""
        
        if let valueText = valueInputField.text {
            let value = numberFormatter.number(from: valueText)
            item.valueInDollars = (value!.intValue)
        } else {
            item.valueInDollars = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {

        // shows which of the 3 fields is firstResponder at this time of tap
        if nameInputField.isFirstResponder {
            print("Ending editing on nameInputField")
        }
        if valueInputField.isFirstResponder {
            print("Ending editing on valueInputField")
        }
        if serialInputField.isFirstResponder {
            print("Ending editing on serialInputField")
        }
        view.endEditing(true)   // convience method to dismiss keyboard without knowing which text field is currently first responder
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeDate" {
            let changeDateViewController = segue.destination as! ChangeDateViewController
            changeDateViewController.item = item
        }
    }
}
