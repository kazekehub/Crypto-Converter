//
//  QuoteTableViewController.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit

protocol QuoteProviderProtocol {
    var delegate: QuoteProviderDelegate? {get set}
    func requestQuotes()
}

class QuoteTableViewController: UITableViewController {
    
    var isSelectQuoteMode = false
    var provider: QuoteProviderProtocol?
    var quoteData: [Quote] = []
    var quoteApi = "https://api.nomics.com/v1/currencies/ticker?key=3c8c0907276523d0ff0e94c50657de0c&format=json&interval=5m&convert=USD"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reseiveQuoteNotification),
                                               name: NotificationSendQuoteList,
                                               object: nil)
    }
    @objc func reseiveQuoteNotification(notification: Notification){
        if let quotes = notification.object as? [Quote] {
            provideQuotes(quotes: quotes)
        }
    }
    
    @IBAction func quoteUpdateClick(_ sender: Any) {
        loadJSON()
        provider = QuoteProvider(delegate: self)
        provider?.requestQuotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJSON()
        provider = QuoteProvider(delegate: self)
        provider?.requestQuotes()
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func loadJSON() {
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
                            self.quoteData = try JSONDecoder().decode([Quote].self, from: data)
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
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCellId", for: indexPath) as! QuoteTableViewCell
        
        let quote = quoteData[indexPath.row]
        cell.quoteImage.image = UIImage(named: quote.logoUrl)
        cell.quoteRankLabel.text = "\(quote.rank)"
        cell.quoteSymbolLabel.text = quote.symbol
        cell.quoteNameLabel.text = quote.name
        cell.quotePriceLabel.text = "$ " + String(format: "%.3f",quote.price)

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? QuoteTableViewCell
        let indexPath = tableView.indexPath(for: cell!)
        let quote = quoteData[indexPath!.row]
        
        if isSelectQuoteMode == true {
            NotificationCenter.default.post(name: NotificationSendSelectedQuote, object: quote)
            self.dismiss(animated: true, completion: nil)
            return
        }
        if let destination = segue.destination as? QuoteDetailViewController {
            destination.quote = quote
        }
    }
}

extension QuoteTableViewController: QuoteProviderDelegate {
    func provideQuotes(quotes: [Quote]) {
        quoteData = quotes
        tableView.reloadData()
    }
}
