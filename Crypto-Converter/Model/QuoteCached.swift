//
//  QuoteCached.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 5/5/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class QuoteCached: Object {
    dynamic var id = ""
    dynamic var currency = ""
    dynamic var symbol = ""
    dynamic var name = ""
    dynamic var rank = ""
    dynamic var price = ""
    dynamic var logoUrl = ""
    dynamic var priceDate = ""
    dynamic var priceTimeStamp = ""
    dynamic var marketCap = ""
    dynamic var circulatingSupply = ""
    dynamic var maxSupply = ""
    dynamic var high = ""
    dynamic var highTimestamp = ""
    dynamic var oneDay : QuoteChanged?
//    var oneDay = List<QuoteChanged>()
    
//    override class func primeryKey() -> String?{
//        return #keyPath(id)
//    }

}

@objcMembers
class QuoteChanged: Object {
    dynamic var priceChange = ""
    dynamic var priceChangePct = ""
    dynamic var volume = ""
    dynamic var volumeChange = ""
    dynamic var volumeChangePct = ""
    dynamic var marketCapChange = ""
    dynamic var marketCapChangePct = ""
}
