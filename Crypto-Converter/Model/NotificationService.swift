//
//  NotificationCenter.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/27/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation

class NotificationService: QuoteProviderDelegate {
    func provideQuotes(quotes: [Quote]) {
        self.quotes = quotes
    }
    
    var timer: Timer?
    var provider: QuoteProviderProtocol?
    var quotes: [Quote] = []
    
    init() {
        provider = QuoteProvider(delegate: self)
    }
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 55.0,
                                     repeats: true,
                                     block: { [weak self]_ in self?.sendMessage()
        })
    }
    func sendMessage() {
        if Reachability.isConnectedToNetwork(){
            provider?.requestQuotes()
            provideQuotes(quotes: quotes)
            if !quotes.isEmpty {
                NotificationCenter.default.post(name: NotificationSendQuoteList, object: quotes)
                print("Notification Sended to Quote")
            }
        }else{
            print("Internet Connection not Available!")
        }
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
