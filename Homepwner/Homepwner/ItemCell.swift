//
//  ItemCell.swift
//  Homepwner
//
//  Created by James Birchall on 31/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.font = bodyFont
        priceLabel.font = bodyFont
        
        let captionFont = UIFont.preferredFont(forTextStyle: .caption1)
        detailLabel.font = captionFont
    }
}
