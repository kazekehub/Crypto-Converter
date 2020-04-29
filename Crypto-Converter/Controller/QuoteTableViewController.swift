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
    var dataArray: [Quote] = []

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
        provider = QuoteProvider(delegate: self)
        provider?.requestQuotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider = QuoteProvider(delegate: self)
        provider?.requestQuotes()
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCellId", for: indexPath) as! QuoteTableViewCell
        
        let quote = dataArray[indexPath.row]
        cell.quoteImage.image = UIImage(named: quote.logourl)
        cell.quoteRankLabel.text = "\(quote.rank)"
        cell.quoteSymbolLabel.text = quote.symbol
        cell.quoteNameLabel.text = quote.name
        cell.quotePriceLabel.text = "$ " + String(format: "%.3f",quote.price)

        return cell
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if isSelectQuoteMode == true, let cell = sender as? QuoteTableViewCell,
        let indexPath = tableView.indexPath(for: cell) {
            let quote = dataArray[indexPath.row]
//            let cell = sender as? QuoteTableViewCell
//            let indexPath = tableView.indexPath(for: cell!)
//            let quote = dataArray[indexPath!.row]
            NotificationCenter.default.post(name: NotificationSendSelectedQuote, object: quote)
            self.dismiss(animated: true, completion: nil)
            return
        }
        if let destination = segue.destination as? QuoteDetailViewController, let cell = sender as? QuoteTableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                        let quote = dataArray[indexPath.row]
                        destination.quote = quote
                    }
        }
}

extension QuoteTableViewController: QuoteProviderDelegate {
    func provideQuotes(quotes: [Quote]) {
        dataArray = quotes
        tableView.reloadData()
    }
}
