//
//  QuoteTableViewController.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder
import JGProgressHUD
import TableViewReloadAnimation

protocol QuoteProviderProtocol {
    var delegate: QuoteProviderDelegate? {get set}
    func requestQuotes()
}

class QuoteTableViewController: UITableViewController {
    
    var isSelectQuoteMode = false
    var quoteData: [Quote] = []
    var provider: QuoteProviderProtocol?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reseiveQuoteNotification),
                                               name: NotificationSendQuoteList,
                                               object: nil)
    }
    @objc func reseiveQuoteNotification(notification: Notification) {
        if let quotes = notification.object as? [Quote]{
            quoteData = quotes
            tableView.reloadData()
        }
    }
    
    @IBAction func quoteUpdateClick(_ sender: Any) {
        provider?.requestQuotes()
        tableView.reloadData(with: .simple(duration: 0.75, direction: .rotation3D(type: .spiderMan),
        constantDelay: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider = QuoteProvider(delegate: self)
        provider?.requestQuotes()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 6.0)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteData.count
    }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCellId", for: indexPath) as! QuoteTableViewCell
        
        
        let quote = quoteData[indexPath.row]
        let imageURL = URL(string: quote.logoUrl!)
        switch indexPath.row {
        case 54...58,92...95,242...247:
            cell.quoteImage.image = (UIImage(named: "placeholder"))
        default:
            cell.quoteImage.sd_setImage(with:imageURL, placeholderImage: UIImage(named: "placeholder"))
        }
        cell.quotePriceChangeLabel.text = quote.oneDay?.priceChangePct
            if quote.oneDay?.priceChangePct?.contains("-") == true {
                cell.quotePriceChangeLabel.textColor = .red
            } else {
                cell.quotePriceChangeLabel.textColor = .systemGreen
            }
        cell.quoteRankLabel.text = quote.rank
        cell.quoteSymbolLabel.text = quote.symbol
        cell.quoteNameLabel.text = quote.name
        cell.quotePriceLabel.text = "$ " + "\(quote.price!)"

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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}
