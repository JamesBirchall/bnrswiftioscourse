//
//  ColourPickerViewController.swift
//  TouchTracker
//
//  Created by James Birchall on 13/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class ColourPickerViewController: UIViewController {

    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    var viewControllerCallingPicker: ViewController?
   
    @IBAction func sliderChanged() {
        updateBackgroundColour()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed() {
        print(#function)
        
        if view.backgroundColor != nil {
            viewControllerCallingPicker?.colourPanelDismissedWithNewColour(colour: view.backgroundColor!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateBackgroundColour() {
        view.backgroundColor = UIColor(colorLiteralRed: redSlider.value, green: greenSlider.value, blue: blueSlider.value, alpha: 1.0)
    }
}
