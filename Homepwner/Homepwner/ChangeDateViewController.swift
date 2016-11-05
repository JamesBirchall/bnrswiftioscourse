//
//  ChangeDateViewController.swift
//  Homepwner
//
//  Created by James Birchall on 05/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class ChangeDateViewController: UIViewController {
    
    var item: Item!
    
    @IBOutlet weak var itemDatePicker: UIDatePicker!

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemDatePicker.date = item.dateCreated
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        item.dateCreated = itemDatePicker.date
    }
}
