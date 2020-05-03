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
    
    let quoteApi = "https://api.nomics.com/v1/currencies/ticker?key=3c8c0907276523d0ff0e94c50657de0c&format=json&convert=USD"
    
    init(delegate: QuoteProviderDelegate) {
      self.delegate = delegate
    }
    
    func loadJSON() {
        guard let url = URL(string: quoteApi) else {
            return
        }
        let quoteLoadTask = URLSession.shared.dataTask(with: url) {
            [weak self]
            (data, response, error) in
            if let data = data {
                do {
                    let quoteData = try JSONDecoder().decode([Quote].self, from: data)
                    self!.delegate?.provideQuotes(quotes: quoteData)
                    } catch {
                        print("Decoding JSON failure")
                    }
                }
            }
        quoteLoadTask.resume()
    }
    
    func requestQuotes() {
          loadJSON()
    }
}
