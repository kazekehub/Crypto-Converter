//
//  ConvertViewController.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/25/20.
//  Copyright © 2020 Kazybek. All rights reserved.

import UIKit
import SDWebImage
import SDWebImageSVGCoder
import SwiftySound

class ConvertViewController: UIViewController,UITextFieldDelegate{
    
    var firstQuote: Quote?
    var secondQuote: Quote?
    var isFirstButtonClicked: Bool?
    private var buttonSound: Sound?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectQuoteNotification),
                                               name: NotificationSendSelectedQuote,
                                               object: nil)
    }
    @objc func selectQuoteNotification(notification: Notification){
        if let quote = notification.object as? Quote {
            if isFirstButtonClicked == true {
                firstQuote = quote
                _ = setButtonImage(button: firstQuoteButton, quote: firstQuote!)
                firstQuoteSymbolLbl.text = quote.symbol!
            } else {
                secondQuote = quote
                _ = setButtonImage(button: secondQuoteButton, quote: secondQuote!)
                secondQuoteSymbolLbl.text = quote.symbol!
            }
        } else {
            print("quote didn't selected")
        }
    }
    
    @IBOutlet weak var firstInputTxtFld: UITextField!
    @IBOutlet weak var secondInputTxtFld: UITextField!
    @IBOutlet weak var firstQuoteButton: UIButton!
    @IBOutlet weak var firstQuoteSymbolLbl: UILabel!
    @IBOutlet weak var secondQuoteButton: UIButton!
    @IBOutlet weak var secondQuoteSymbolLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstInputTxtFld.delegate = self
        secondInputTxtFld.delegate = self
        
        if let buttonUrl = Bundle.main.url(forResource: "ButtonClick_Sound", withExtension: "wav") {
            buttonSound = Sound(url: buttonUrl)
        }
    }
    
    func setButtonImage(button: UIButton, quote: Quote) -> UIButton {
        let imageURL = URL(string: quote.logoUrl!)
        button.sd_setImage(with:imageURL, for: .normal, placeholderImage: UIImage(named: "placeholder"))
        return button
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let firstQuote = firstQuote,
            let secondQuote = secondQuote else { return }
        var count: Double? {
            return Double(firstInputTxtFld.text!)
        }
        var firstPrice: Double? {
            return Double(firstQuote.price!)
        }
        var secondPrice: Double?{
            return Double(secondQuote.price!)
        }
        if firstInputTxtFld.isEditing == true, firstInputTxtFld.text != "" {
            let baseQuote = Converter(baseQuote: secondPrice!)
            secondInputTxtFld.text = baseQuote.converter(count: count!, convertQuote: firstPrice!)
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
        Sound.play(file: "ButtonClick_Sound", fileExtension: "wav", numberOfLoops: 0)
    }
        
    @IBAction func secondQuoteButtonClick(_ sender: Any) {
        isFirstButtonClicked = false
        Sound.play(file: "ButtonClick_Sound", fileExtension: "wav", numberOfLoops: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? QuoteTableViewController {
            destination.isSelectQuoteMode = true
        }
    }
}
