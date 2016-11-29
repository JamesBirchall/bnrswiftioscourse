//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by James Birchall on 29/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
            
        }
    }
    
    override func awakeFromNib() {
        // function runs when the cell is reloaded and connected up
        super.awakeFromNib()
        
        spinner.hidesWhenStopped = true
        
        updateWithImage(image: nil) // we know there is no image right now
    }
    
    override func prepareForReuse() {
        // called when cell is about to be reused
        super.prepareForReuse()
        
        updateWithImage(image: nil) // we want this cell to go back to spinner
    }
}
