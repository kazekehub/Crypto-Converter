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
import RealmSwift

protocol QuoteProviderProtocol {
    var delegate: QuoteProviderDelegate? {get set}
    func requestQuotes()
}

class QuoteTableViewController: UITableViewController {
    
    var isSelectQuoteMode = false
    var quoteData: [Quote] = []
    var provider: QuoteProviderProtocol?
    let defaults = UserDefaults.standard
    let hud = JGProgressHUD(style: .dark)
//    var modelData: [QuoteCached] = []
    var isRealmDataDeleted = false
    var quoteCachedProvider = QuoteCachedProvider()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reseiveQuoteNotification),
                                               name: NotificationSendQuoteList,
                                               object: nil)
    }
    @objc func reseiveQuoteNotification(notification: Notification) {
        if let quotes = notification.object as? [Quote] {
            quoteData = quotes
            provider = QuoteProvider(delegate: self)
            provider?.requestQuotes()
        }
    }
    
    @IBAction func quoteUpdateClick(_ sender: Any) {
        provider = QuoteProvider(delegate: self)
        provider?.requestQuotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "First Laucnh") == true {
            if let quotes = self.quoteCachedProvider.readQuotes(){
                self.quoteData = quotes
            } //else {
//                provider?.requestQuotes()
//            }
            showSimpleAlert(message: "Welcome Back \n I'm glad to see you again 🥳")
            defaults.set(true,forKey: "First Laucnh")
        } else {
            showSimpleAlert(message: "HI! Welcome to my app \n 😎")
            provider = QuoteProvider(delegate: self)
            provider?.requestQuotes()
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
            defaults.set(true,forKey: "First Laucnh")
        }
    }
    
    func showSimpleAlert(message: String) {
        let alert = UIAlertController(title: message, message: "",         preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
           }))
           self.present(alert, animated: true, completion: nil)
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
        
        let realmQuote = quoteData[indexPath.row]
        let imageURL = URL(string: realmQuote.logoUrl!)
        //DAI,XVG,DRGN ->> библиотека не читает svg файлы указанных котировок, поэтому вручную загрузил
        switch realmQuote.symbol {
            case "DAI":
                cell.quoteImage.image = (UIImage(named: "DAI"))
            case "XVG":
                cell.quoteImage.image = (UIImage(named: "XVG"))
            case "DRGN":
                cell.quoteImage.image = (UIImage(named: "DRGN"))
            default:
                cell.quoteImage.sd_setImage(with:imageURL, placeholderImage: UIImage(named: "placeholder"))
        }
        
        cell.quoteRankLabel.text = realmQuote.rank
        cell.quoteSymbolLabel.text = realmQuote.symbol
        cell.quoteNameLabel.text = realmQuote.name
        cell.quotePriceChangeLabel.text = realmQuote.oneDay?.priceChangePct
        if realmQuote.oneDay?.priceChangePct!.contains("-") == true {
            cell.quotePriceChangeLabel.textColor = .red
        } else {
            cell.quotePriceChangeLabel.textColor = .systemGreen
        }
        
        var quotePrice: Double? {
            return Double(realmQuote.price!)
        }
        cell.quotePriceLabel.text = "$ " + String(format: "%.4f", quotePrice!)
        
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
        self.quoteCachedProvider.saveAndUpdateQuotes(quotes: quotes)
        DispatchQueue.main.async {
            self.hud.dismiss()
            self.tableView.reloadData()
        }
    }
}
