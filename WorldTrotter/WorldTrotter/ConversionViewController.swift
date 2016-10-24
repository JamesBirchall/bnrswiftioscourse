//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by James Birchall on 12/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit
import CoreLocation

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    var locationManager: CLLocationManager!
    
    var fahrenheitValue: Double? {
        didSet {
            updateCelciusLabel()
        }
    }
    
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        } else {
            return nil
        }
    }
    
    var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }

    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    @IBAction func farhFieldEditingChanged(textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = value
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
    func updateCelciusLabel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.string(for: value)
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        // look for character in string - if found return false straight away!
        // bronze challenge
        let isDigit = string.rangeOfCharacter(from: CharacterSet.decimalDigits)

        let existingTextHasDecimalSeperator = textField.text?.range(of: ".")
        
        let replacementTextHasDecimalSeperator = string.range(of: ".")
        
        if isDigit == nil {
            
            // check character isn't "."
            if string != "." {
                return false
            }
        }
        
        if existingTextHasDecimalSeperator != nil && replacementTextHasDecimalSeperator != nil {
            return false
        } else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set colour of background here - light for daytime, dark for nighttime
        // silver challenge
        
        // get lat and long values for current location
        
        let locationStatus = CLLocationManager.authorizationStatus()
        
        if locationStatus == .denied || locationStatus == .restricted {
            print("Cannot use location services - denied or restricted.")
        } else {
            locationManager = CLLocationManager()
            if locationStatus == .notDetermined {
                locationManager?.requestWhenInUseAuthorization()
                
                if locationStatus == .authorizedWhenInUse {
                    CLLocationManager.locationServicesEnabled()
                    print("Location service enabled...")
                }
            }
        }
        
        let latitude = locationManager?.location?.coordinate.latitude
        let longitude = locationManager?.location?.coordinate.longitude
        
        if latitude != nil && longitude != nil {
            print("Lat: \(latitude) : Lon: \(longitude)")
            
            var currentDate = Date()
            
            let solar = Solar(forDate: currentDate, withTimeZone: .current, latitude: latitude!, longitude: longitude!)
            
            let sunriseUTC = solar?.sunrise
            let sunsetUTC = solar?.sunset
            
            let timeZone = NSTimeZone()
            
            let sunrise: Date?
            let sunset: Date?
            
            timeZone.localizedName(.daylightSaving, locale: nil)
            
            if !timeZone.isDaylightSavingTime {
                // offset Daylight saving time if present
                sunrise = Date(timeInterval: 60 * 60, since: sunriseUTC!)
                sunset = Date(timeInterval: 60 * 60, since: sunsetUTC!)
                currentDate = Date(timeInterval: 60 * 60, since: currentDate)
                //print("Sunrise \(sunrise!) : Sunset \(sunset!)")
            } else {
                sunrise = sunriseUTC
                sunset = sunsetUTC
            }
            
            print("Now: \(currentDate), Sunrise today: \(sunrise), Sunset today: \(sunset)")
            
            if sunrise != nil && sunset != nil {    // check for nil
                if currentDate >= sunrise! && currentDate <= sunset! {
                    
                    self.view.backgroundColor = UIColor.yellow
                    print("Daytime - yellow background")
                }
                else {
                    self.view.backgroundColor = UIColor.darkGray
                    print("Nighttime - dark grey background")
                }
            }
        }
    }
}
