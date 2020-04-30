//
//  NotificationCenter.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/27/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation

 class NotificationService {
    var timer: Timer?
//    lazy var quoteProvider = QuoteProvider(delegate: self)
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 60,
                                     repeats: true,
                                     block: { [weak self]_ in self?.sendMessage()
                                        
        })
    }
    
    func sendMessage() {
//        quoteProvider.requestQuotes()
    }
        
    func stop(){
        timer?.invalidate()
        timer = nil
        
    }
}

//extension NotificationService: QuoteProviderDelegate {
//    func provideQuotes(quotes: [Quote]) {
//        NotificationCenter.default.post(name: NotificationSendQuoteList, object: quotes)
//    }
//}
