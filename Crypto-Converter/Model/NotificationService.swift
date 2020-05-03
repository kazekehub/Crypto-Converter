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
    var provider: QuoteProviderProtocol?
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0,
                                     repeats: true,
                                     block: { [weak self]_ in self?.sendMessage()
        })
    }
    
    func sendMessage() {
        provider?.requestQuotes()
//         NotificationCenter.default.post(name: NotificationSendQuoteList, object: Any?)
    }

    func stop() {
        timer?.invalidate()
        timer = nil

    }
}



//  var timer: Timer?
//
//    func sendNotification(){
//        NotificationCenter.default.post(name: NotificationSendQuoteList, object: quoteData)
//    }

//    func restartTimer() {
//        sendNotification()
//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: true) { timer in self.loadJSON() }
//    }

