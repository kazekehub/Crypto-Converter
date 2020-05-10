//
//  QuoteCached.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 5/5/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation
import RealmSwift

class QuoteCached: Object {
    @objc dynamic var id = ""
    @objc dynamic var currency = ""
    @objc dynamic var symbol = ""
    @objc dynamic var name = ""
    @objc dynamic var rank = ""
    @objc dynamic var price = ""
    @objc dynamic var logoUrl = ""
    @objc dynamic var priceDate = ""
    @objc dynamic var priceTimeStamp = ""
    @objc dynamic var marketCap = ""
    @objc dynamic var circulatingSupply = ""
    @objc dynamic var maxSupply = ""
    @objc dynamic var high = ""
    @objc dynamic var highTimestamp = ""
    
    @objc dynamic var priceChange = ""
    @objc dynamic var priceChangePct = ""
    @objc dynamic var volume = ""
    @objc dynamic var volumeChange = ""
    @objc dynamic var volumeChangePct = ""
    @objc dynamic var marketCapChange = ""
    @objc dynamic var marketCapChangePct = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(quote: Quote) {
        self.init()
        id = quote.id
        currency = quote.currency ?? ""
        symbol = quote.symbol ?? ""
        name = quote.name ?? ""
        rank = quote.rank ?? ""
        price = quote.price ?? ""
        logoUrl = quote.logoUrl ?? ""
        priceDate = quote.priceDate ?? ""
        priceTimeStamp = quote.priceTimeStamp ?? ""
        marketCap = quote.marketCap ?? ""
        circulatingSupply = quote.circulatingSupply ?? ""
        maxSupply = quote.maxSupply ?? ""
        high = quote.high ?? ""
        highTimestamp = quote.highTimestamp ?? ""
        
        priceChange = quote.oneDay?.priceChange ?? ""
        priceChangePct = quote.oneDay?.priceChangePct ?? ""
        volume = quote.oneDay?.volume ?? ""
        volumeChange = quote.oneDay?.volumeChange ?? ""
        volumeChangePct = quote.oneDay?.volumeChangePct ?? ""
        marketCapChange = quote.oneDay?.marketCapChange ?? ""
        marketCapChangePct = quote.oneDay?.marketCapChangePct ?? ""
    }
}

