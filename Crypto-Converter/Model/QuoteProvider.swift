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
    let quoteApi = "https://api.nomics.com/v1/currencies/ticker?key=3c8c0907276523d0ff0e94c50657de0c&format=json&interval=5m&convert=USD"
    
    
    init(delegate: QuoteProviderDelegate) {
        self.delegate = delegate

      }
    
    func loadJSON(quoteData: [Quote]) {
        if let url = URL(string: quoteApi) {
            let quoteLoadTask =
                URLSession.shared.dataTask(with: url) {
                    [weak self]
                    (data, response, error)
                    in
                    guard let self = self else {
                        return
                    }
                    if let data = data {
                        do {
                            quoteData = try JSONDecoder().decode([Quote].self, from: data)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        } catch {
                            print("Decoding JSON failure")
                        }
                    }
            }
            quoteLoadTask.resume()
        }
    }
    
    
    func requestQuotes() {
        let quotes = QuoteProvider.generateQuotes()
        delegate?.provideQuotes(quotes:quotes)
    }
    
}
