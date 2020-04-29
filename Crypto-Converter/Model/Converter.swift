//
//  Converter.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation

class Converter {
    
    var baseQuote : Double
    init(baseQuote: Double){
        self.baseQuote = baseQuote
    }
    
    func converter(count: Double, convertQuote: Double) -> String {
        let result = (count * convertQuote) / baseQuote
        return String(format: "%.3f", result)
    }
}
