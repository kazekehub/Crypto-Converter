//
//  QuoteDetailViewController.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit

class QuoteDetailViewController: UIViewController {
    
    var quote: Quote?
    
    @IBOutlet weak var quoteImage: UIImageView!
    @IBOutlet weak var quoteNameLbl: UILabel!
    @IBOutlet weak var quoteSymbolLbl: UILabel!
    @IBOutlet weak var quoteRankLbl: UILabel!
    @IBOutlet weak var quotePriceLbl: UILabel!
    @IBOutlet weak var quotePriceDateLbl: UILabel!
    @IBOutlet weak var quotePriceTimeStampLbl: UILabel!
    @IBOutlet weak var quoteMarketCapLbl: UILabel!
    @IBOutlet weak var quoteCirculatinSupplyLbl: UILabel!
    @IBOutlet weak var quoteMaxSupplyLbl: UILabel!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = quote!.name

        quoteImage.image = UIImage(named: quote!.logoUrl)
        quoteNameLbl.text = quote!.name
        quoteSymbolLbl.text = quote!.symbol
        quoteRankLbl.text = "\(quote!.rank)"
        quotePriceLbl.text = "$ " + String(format: "%.3f",quote!.price)
        quotePriceDateLbl.text = quote!.priceDate
        quotePriceTimeStampLbl.text = quote!.priceTimeStamp
        quoteMarketCapLbl.text = "\(quote!.marketCap)"
        quoteCirculatinSupplyLbl.text = "\(quote!.circulatingSupply)"
        quoteMaxSupplyLbl.text = "\(quote!.maxSupply)"
      
    }
}

