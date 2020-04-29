//
//  Quote.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation

struct Quote {
    var id: String
    var currency: String
    var symbol: String
    var name: String
    var rank: Int
    var price: Double
    var logourl: String
    var priceDate: String
    var priceTimeStamp: String
    var marketCap: Int
    var circulatingSupply: Int
    var maxSupply: Int
}
