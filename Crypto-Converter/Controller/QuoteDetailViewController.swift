//
//  QuoteDetailViewController.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class QuoteDetailViewController: UIViewController {
    
    var quote: QuoteCached?
    
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
        
        let imageURL = URL(string: (quote?.logoUrl)!)
        //DAI,XVG,DRGN ->> библиотека не читает svg файлы указанных котировок, поэтому вручную загрузил
        switch quote?.symbol {
               case "DAI":
                   quoteImage.image = (UIImage(named: "DAI"))
               case "XVG":
                    quoteImage.image = (UIImage(named: "XVG"))
               case "DRGN":
                   quoteImage.image = (UIImage(named: "DRGN"))
               default:
                     quoteImage.sd_setImage(with:imageURL, placeholderImage: UIImage(named: "placeholder"))
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

