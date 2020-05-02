//
//  QuoteTableViewCell.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {
    @IBOutlet weak var quoteRankLabel: UILabel!
    @IBOutlet weak var quoteImage: UIImageView!
    @IBOutlet weak var quoteNameLabel: UILabel!
    @IBOutlet weak var quoteSymbolLabel: UILabel!
    @IBOutlet weak var quotePriceLabel: UILabel!
    @IBOutlet weak var quotePriceChangeLabel: UILabel!
}
