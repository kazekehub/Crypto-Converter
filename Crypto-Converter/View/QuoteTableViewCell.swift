//
//  QuoteTableViewCell.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 5
        cardView.layer.shadowColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        cardView.layer.shadowRadius = 10
            }
    @IBOutlet weak var quoteRankLabel: UILabel!
    @IBOutlet weak var quoteImage: UIImageView!
    @IBOutlet weak var quoteNameLabel: UILabel!
    @IBOutlet weak var quoteSymbolLabel: UILabel!
    @IBOutlet weak var quotePriceLabel: UILabel!
    @IBOutlet weak var quotePriceChangeLabel: UILabel!
}
