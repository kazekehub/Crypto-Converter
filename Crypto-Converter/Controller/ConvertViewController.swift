//
//  ConvertViewController.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/25/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit

class ConvertViewController: UIViewController,UITextFieldDelegate {
    
    var firstQuote: Quote?
    var secondQuote: Quote?
    var isFirstButtonClicked: Bool?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectQuoteNotification),
                                               name: NotificationSendSelectedQuote,
                                               object: nil)
    }
    @objc func selectQuoteNotification(notification: Notification){
        if let quotes1 = notification.object as? Quote {
            if isFirstButtonClicked == true {
                firstQuote = quotes1
                firstQuoteButton.setImage(UIImage(named: firstQuote!.logoUrl), for: .normal)
            } else {
                secondQuote = quotes1
                print("")
                secondQuoteButton.setImage(UIImage(named: secondQuote!.logoUrl), for: .normal)
            }
        } else {
            print("quote didn't selected")
        }
    }
    
    @IBOutlet weak var firstInputTxtFld: UITextField!
    @IBOutlet weak var secondInputTxtFld: UITextField!
    @IBOutlet weak var firstQuoteButton: UIButton!
    @IBOutlet weak var secondQuoteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstInputTxtFld.delegate = self
        secondInputTxtFld.delegate = self
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let firstQuote = firstQuote,
            let secondQuote = secondQuote else { return
        }
        if firstInputTxtFld.isEditing == true, firstInputTxtFld.text != "" {
            let baseQuote = Converter(baseQuote: firstQuote.price)
            var count: Double? {
                return Double(firstInputTxtFld.text!)
            }
            secondInputTxtFld.text = baseQuote.converter(count: count!, convertQuote: secondQuote.price)
        } else {
            secondInputTxtFld.text = ""
            }
        }
            
    @IBAction func hideKeyBoard(_ sender: Any) {
        firstInputTxtFld.resignFirstResponder()
        secondInputTxtFld.resignFirstResponder()
    }
    
    @IBAction func firstQuoteButtonClick(_ sender: Any) {
        isFirstButtonClicked = true
    }
        
    @IBAction func secondQuoteButtonClick(_ sender: Any) {
        isFirstButtonClicked = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? QuoteTableViewController {
            destination.isSelectQuoteMode = true
        }
    }
}
