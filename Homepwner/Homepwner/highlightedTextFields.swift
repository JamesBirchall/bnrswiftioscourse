//
//  highlightedTextFields.swift
//  Homepwner
//
//  Created by James Birchall on 05/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class highlightedTextFields: UITextField {

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        // user layer to change border
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 3.0
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.1
        return true
    }
}
