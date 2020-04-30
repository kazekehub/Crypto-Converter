//
//  QuoteDetailViewController.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import SVGKit
import SDWebImage

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
    @IBOutlet weak var quoteHighLbl: UILabel!
    @IBOutlet weak var quoteHighTimestampLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = quote!.name
            
        if let svg = URL(string: (quote?.logoUrl!)!), let data = try? Data(contentsOf: svg), let receivedimage: SVGKImage = SVGKImage(data: data) {
            quoteImage.image = receivedimage.uiImage
        } else {
            quoteImage?.sd_setImage(with: URL(string:(quote?.logoUrl!)!), placeholderImage:nil)
        }
        
        quoteNameLbl.text = quote!.name
        quoteSymbolLbl.text = quote!.symbol
        quoteRankLbl.text = quote!.rank
        quotePriceLbl.text = quote!.price
        quotePriceDateLbl.text = quote!.priceDate
        quotePriceTimeStampLbl.text = quote!.priceTimeStamp
        quoteMarketCapLbl.text = quote!.marketCap
        quoteCirculatinSupplyLbl.text = quote!.circulatingSupply
        quoteMaxSupplyLbl.text =  quote?.maxSupply
        quoteHighLbl.text = quote!.high
        quoteHighTimestampLbl.text = quote!.highTimestamp
      
    }
}

