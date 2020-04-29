//
//  QuoteProvider.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation
protocol QuoteProviderDelegate {
    func provideQuotes(quotes: [Quote])
}

class QuoteProvider: QuoteProviderProtocol {
    var delegate: QuoteProviderDelegate?
    
    init(delegate: QuoteProviderDelegate) {
        self.delegate = delegate

      }
    
    private class func generateQuotes() ->[Quote]{
         
         let array = [
             Quote(id: "BTC", currency: "BTC", symbol: "BTC", name: "Bitcoin", rank: 1, price: Double.random(in: 0...10000), logourl: "Bitcoin", priceDate: "2020-04-17T00:00:00Z", priceTimeStamp:"2020-04-17T17:18:00Z", marketCap: 129443364510, circulatingSupply: 18330312, maxSupply: 21000000),
             Quote(id: "ETH", currency: "ETH", symbol: "ETH", name: "Ethereum", rank: 2, price: Double.random(in: 0...10000), logourl: "Ethereum", priceDate: "2020-04-17T00:00:00Z", priceTimeStamp: "2020-04-17T17:18:00Z", marketCap: 18889996129, circulatingSupply: 110557882, maxSupply: Int.random(in: 0...10000)),
             Quote(id:  "XRP", currency: "XRP", symbol: "XRP", name: "Ripple", rank: 3, price: Double.random(in: 0...10000), logourl: "Ripple", priceDate: "2020-04-17T00:00:00Z", priceTimeStamp: "2020-04-17T17:18:00Z", marketCap: 8301433484, circulatingSupply: 44089620959, maxSupply: 100000000000),
             Quote(id: "USDT", currency: "USDT", symbol: "USDT", name: "Tether", rank: 4, price: Double.random(in: 0...10000), logourl: "Tether", priceDate: "2020-04-17T00:00:00Z", priceTimeStamp: "2020-04-17T17:18:00Z", marketCap: 6919451547, circulatingSupply: 6917756658, maxSupply: Int.random(in: 0...10000)),
             Quote(id: "BCH", currency: "BCH", symbol: "BCH", name: "Bitcoin Cash", rank: 5, price: Double.random(in: 0...10000), logourl: "BitcoinCash", priceDate: "2020-04-17T00:00:00Z", priceTimeStamp: "2020-04-17T00:00:00Z", marketCap: 4283393536, circulatingSupply: 18382577, maxSupply: 21000000)

         ]
         return array
     }
    func requestQuotes() {
        let quotes = QuoteProvider.generateQuotes()
        delegate?.provideQuotes(quotes:quotes)
    }
    
}
