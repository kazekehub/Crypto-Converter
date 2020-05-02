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
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0,
                                     repeats: true,
                                     block: { [weak self]_ in self?.sendMessage()
        })
    }
    
    func sendMessage() {
        
    }
        
    func stop(){
        timer?.invalidate()
        timer = nil
        
    }
}

