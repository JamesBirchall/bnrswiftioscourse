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
    
    var imageStore: ImageStore!
    
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
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameInputField.text = item.name
        serialInputField.text = item.serialNumber
//        valueInputField.text = "\(item.valueInDollars)"
//        dateCreatedLabel.text = "\(item.dateCreated)"
        
        valueInputField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateCreatedLabel.text = dateFormatter.string(from: item.dateCreated)
        
        // set image correctly
        let key = item.itemKey
        if let imageToShow = imageStore.imageForKey(key: key) {
            imageView.image = imageToShow
        }
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
    
    // MARK: - Connected Actions
    
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

    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self // set delegate for Photo Picker to this class instance
        
        // Gold Challenge

        let crosshairImage = UIImage(named: "crosshairicon.png")
        let crosshairImageView = UIImageView(image: crosshairImage)
        
        // bronze challenge
        imagePicker.allowsEditing = true
        
        // show an options box for selecting library or camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // let the user decids
            let title = "Add an image?"
            let message = "Select options for adding your image."
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                (action) -> Void in
                imagePicker.sourceType = .camera
                crosshairImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)  // 100 by 100 image
                crosshairImageView.center = (imagePicker.cameraOverlayView?.center)!
                crosshairImageView.center.y = crosshairImageView.center.y - 25
                imagePicker.cameraOverlayView = crosshairImageView
                self.present(imagePicker, animated: true, completion: nil)  // show the actual imagePicker
            })
            alertController.addAction(cameraAction)
            
            // photo library option
            let photoLibraryAction = UIAlertAction(title: "Photos", style: .default, handler: {
                (action) -> Void in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)   // show the actual imagePicker
            })
            alertController.addAction(photoLibraryAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            imagePicker.sourceType = .photoLibrary
            // Place imagePicker on the screen
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func removeImage(_ sender: UIBarButtonItem) {
        let key = item.itemKey
        
        if imageView.image != nil {
            imageStore.deleteImageForKey(key: key)
            imageView.image = nil   // shut down imageView
        }
    }
    
    // MARK - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // delegate method from UIImagePickerControllerDelegate
        // get picked image from dictionary
        //let image = info[UIImagePickerControllerOriginalImage] as! UIImage  // have to force cast into UIImage from Any?
        
        let image = info[UIImagePickerControllerEditedImage] as! UIImage  // have to force cast into UIImage from Any?
        
        imageStore.setImage(image: image, forKey: item.itemKey) // this overwrites any existing image
        
        imageView.image = image // set imageView correctly to selected image
        
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK - Segue Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeDate" {
            let changeDateViewController = segue.destination as! ChangeDateViewController
            changeDateViewController.item = item
        }
    }
}
