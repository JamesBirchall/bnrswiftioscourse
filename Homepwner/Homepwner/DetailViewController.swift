//
//  DetailViewController.swift
//  Homepwner
//
//  Created by James Birchall on 31/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    @IBOutlet weak var imageView: UIImageView!
    
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

    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        // if device doesn't have camera use library
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self // set delegate for Photo Picker to this class instance
        
        //imagePicker.allowsEditing = true
        
        // Place imagePicker on the screen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // delegate method from UIImagePickerControllerDelegate
        // get picked image from dictionary
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage  // have to force cast into UIImage from Any?
        
        imageView.image = image // set imageView correctly to selected image
        
        dismiss(animated: true, completion: nil)
    }
    
}
