//
//  Quote.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation

struct Quote: Decodable {
    var id: String
    var currency: String?
    var symbol: String?
    var name: String?
    var rank: String?
    var price: String?
    var logoUrl: String?
    var priceDate: String?
    var priceTimeStamp: String?
    var marketCap: String?
    var circulatingSupply: String?
    var maxSupply: String?
    var high: String?
    var highTimestamp: String?
    var oneDay: QuoteChanges?

    enum CodingKeys: String, CodingKey {
        case id
        case currency
        case symbol
        case name
        case logoUrl = "logo_url"
        case rank
        case price
        case priceDate = "price_date"
        case priceTimeStamp = "price_timestamp"
        case marketCap = "market_cap"
        case circulatingSupply = "circulating_supply"
        case maxSupply = "max_supply"
        case high
        case highTimestamp = "high_timestamp"
        case oneDay = "1d"
      }
}

struct QuoteChanges: Decodable {
    var priceChange: String?
    var priceChangePct: String?
    var volume: String?
    var volumeChange: String?
    var volumeChangePct: String?
    var marketCapChange: String?
    var marketCapChangePct: String?
    
    enum CodingKeys: String, CodingKey {
        case priceChange = "price_change"
        case priceChangePct = "price_change_pct"
        case volume
        case volumeChange = "volume_change"
        case volumeChangePct = "volume_change_pct"
        case marketCapChange = "market_cap_change"
        case marketCapChangePct = "market_cap_change_pct"
    }
}
