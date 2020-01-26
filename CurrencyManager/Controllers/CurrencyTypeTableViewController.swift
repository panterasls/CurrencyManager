//
//  CurrencyTypeTableViewController.swift
//  CurrencyManager
//
//  Created by Надежда Возна on 25.01.2020.
//  Copyright © 2020 Надежда Возна. All rights reserved.
//

import UIKit

class CurrencyTypeTableViewController: UITableViewController {
    
    private var currencyArray = [(symbol: String, name: String)]()
    private var currentCurrency = ""
    private let index = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyArray = [("$", "USD"), ("€", "EURO"), ("₽", "RUB")]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("currentCurrency: \(currentCurrency)")
        currentCurrency = currencyArray[index.integer(forKey: "index")].symbol
        if self.isMovingToParent {
            index.set(currentCurrency, forKey: "currSymbol")
            print("currentCurrency: \(currentCurrency)")
        }
    }
}

extension CurrencyTypeTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currCell", for: indexPath) as! CurrencyTypeTableViewCell
        cell.currSymbolLabel.text = currencyArray[indexPath.row].symbol
        cell.currNameLabel.text = currencyArray[indexPath.row].name
        let i = IndexPath(row: index.integer(forKey: "index"), section: 0)
        if flag {
            if indexPath == myIndexPath {
                cell.accessoryType = .checkmark
            }
        } else {
            if indexPath == i {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        for cellPath in tableView.indexPathsForVisibleRows! {
            if cellPath == indexPath {
                if let cell = tableView.cellForRow(at: indexPath) {
                    if cell.accessoryType == .checkmark {
                        index.set(indexPath.row, forKey: "index")
                        flag = true
                        myIndexPath = indexPath
                    }
                }
                continue
            }
            tableView.cellForRow(at: cellPath)!.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
