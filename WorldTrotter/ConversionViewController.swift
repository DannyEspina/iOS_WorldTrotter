//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Danny Espina on 9/28/17.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue{
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
        updateCelsiusLabel()
    }
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        let replacementTextHasLetters = string.rangeOfCharacter(from: NSCharacterSet.letters)
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil ||
            replacementTextHasLetters != nil{
            return false
        } else {
            return true
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        if hour > 17 {
            self.view.backgroundColor = UIColor.darkGray
        }
    }
}
