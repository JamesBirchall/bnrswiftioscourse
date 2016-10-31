//
//  DetailViewController.swift
//  Homepwner
//
//  Created by James Birchall on 31/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var item: Item!
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameInputField.text = item.name
        serialInputField.text = item.serialNumber
//        valueInputField.text = "\(item.valueInDollars)"
//        dateCreatedLabel.text = "\(item.dateCreated)"
        
        valueInputField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateCreatedLabel.text = dateFormatter.string(from: item.dateCreated)
    }
}