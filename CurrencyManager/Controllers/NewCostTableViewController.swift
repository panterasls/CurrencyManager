//
//  NewCostTableViewController.swift
//  CurrencyManager
//
//  Created by Надежда Возна on 22.01.2020.
//  Copyright © 2020 Надежда Возна. All rights reserved.
//

import UIKit
import CoreData

class NewCostTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    private let typePicker = UIPickerView()
    private let settings = UserDefaults.standard
    private var amountTypeArray: [(icon: String, name: String)] = [
        ("🚖", "Taxi"), ("🛍", "Shopping"), ("🍟", "Food"), ("👶", "Child"),
        ("👕", "Clothes"), ("👟", "Footwear"), ("💄", "Cosmetics"),
        ("🏠", "House"), ("🚗", "Car"), ("📱", "Smart device"), ("✅", "Other")]
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.dataSource = self
        typePicker.delegate = self
        typeTextField.inputView = typePicker
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    //MARK: - doneBarButtonAction
    
    @IBAction func doneBarButtonAction(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || countTextField.text == "" {
            if nameTextField.text == "" && countTextField.text == "" {
                performSegue(withIdentifier: "unwindToCostsViewController", sender: self)
            } else if nameTextField.text == "" {
                let alert = UIAlertController(title: "Title is empty", message: "Enter title", preferredStyle: .alert)
                let done = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(done)
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Count is empty", message: "Enter count", preferredStyle: .alert)
                let done = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(done)
                present(alert, animated: true, completion: nil)
            }
        } else {
            let coreData = CoreData()
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, HH:mm:ss"
            let dateResult = formatter.string(from: date)
            var value = ""
            var finalName = ""
            if let name = nameTextField.text {
                finalName = name
            } else {
                print("nameTextField is empty")
            }
            if let count = countTextField.text {
                value = count
                let oldBalance = settings.double(forKey: "amount")
                settings.set(Double(count)! + settings.double(forKey: "sum"), forKey: "sum")
                let fullSum = settings.double(forKey: "sum")
                settings.set(oldBalance - fullSum, forKey: "balance")
                print("balance = \(settings.double(forKey: "balance"))")
            } else {
                print("countTextField is empty")
            }
            if typeTextField.text == "" {
                typeTextField.text = amountTypeArray.last?.name
            }
            settings.set(typeTextField.text, forKey: "amountType")
            coreData.save(date: dateResult, name: finalName, value: value)
            coreData.fetch()
            performSegue(withIdentifier: "unwindToCostsViewController", sender: self)
            print("return")
        }
    }
}

//MARK: - extension for Picker

extension NewCostTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        typeTextField.text = amountTypeArray.first?.name
        return amountTypeArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return amountTypeArray[row].icon + " " + amountTypeArray[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = amountTypeArray[row].name
    }
}
