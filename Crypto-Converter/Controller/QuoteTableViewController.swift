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
    var modelData: [QuoteCached] = []
    var isRealmDataDeleted = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reseiveQuoteNotification),
                                               name: NotificationSendQuoteList,
                                               object: nil)
    }
    @objc func reseiveQuoteNotification(notification: Notification) {
        if let quotes = notification.object as? [Quote] {
            readQuotes()
            quoteData = quotes
            provider?.requestQuotes()
            deleteQuote()
        }
    }
    
    @IBAction func quoteUpdateClick(_ sender: Any) {
        readQuotes()
        provider?.requestQuotes()
        deleteQuote()
//        tableView.reloadData(with: .simple(duration: 0.75, direction: .rotation3D(type: .doctorStrange), constantDelay: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "First Laucnh") == true{
            readQuotes()
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
    
    func saveQuotesToRealm(quote: QuoteCached) {
       let realm = try! Realm()
        do {
            try realm.write {
                realm.add(quote)
            }
        } catch {
            print("Failed to save quotes. \(error)")
        }
    }
    
    func saveToRealm() {
        for quote in quoteData {
            let modelData = QuoteCached()
            modelData.oneDay = QuoteChanged()
            
            modelData.id = quote.id
            modelData.currency = quote.currency ?? ""
            modelData.symbol = quote.symbol ?? ""
            modelData.name = quote.name ?? ""
            modelData.rank = quote.rank ?? ""
            modelData.price = quote.price ?? ""
            modelData.logoUrl = quote.logoUrl ?? ""
            modelData.priceDate = quote.priceDate ?? ""
            modelData.priceTimeStamp = quote.priceTimeStamp ?? ""
            modelData.marketCap = quote.marketCap ?? ""
            modelData.circulatingSupply = quote.circulatingSupply ?? ""
            modelData.maxSupply = quote.maxSupply ?? ""
            modelData.high = quote.high ?? ""
            modelData.highTimestamp = quote.highTimestamp ?? ""
            
            modelData.oneDay?.priceChange = quote.oneDay?.priceChange ?? ""
            modelData.oneDay?.priceChangePct = quote.oneDay?.priceChangePct ?? ""
            modelData.oneDay?.volume = quote.oneDay?.volume ?? ""
            modelData.oneDay?.volumeChange = quote.oneDay?.volumeChange ?? ""
            modelData.oneDay?.volumeChangePct = quote.oneDay?.volumeChangePct ?? ""
            modelData.oneDay?.marketCapChange = quote.oneDay?.marketCapChange ?? ""
            modelData.oneDay?.marketCapChangePct = quote.oneDay?.marketCapChangePct ?? ""
           
            saveQuotesToRealm(quote: modelData)
        }
    }
    
    func readQuotes() {
        do {
           let realm = try! Realm()
            let result = try realm.objects(QuoteCached.self)
            result.forEach { quote in
                modelData.append(quote)
            }
            print(modelData[0].name)
        } catch {
            print("error \(error)")
        }
    }
    
    func deleteQuote() {
        do {
            let realm = try! Realm()
            try? realm.write {
                realm.deleteAll()
                self.modelData.removeAll()
                isRealmDataDeleted = true
                print("delete finish \(isRealmDataDeleted)")
            }
         } catch {
            print("error \(error)")
        }
    }
     
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.count
    }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCellId", for: indexPath) as! QuoteTableViewCell
        
        let realmQuote = modelData[indexPath.row]
        let imageURL = URL(string: realmQuote.logoUrl)
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
        if realmQuote.oneDay?.priceChangePct.contains("-") == true {
            cell.quotePriceChangeLabel.textColor = .red
        } else {
            cell.quotePriceChangeLabel.textColor = .systemGreen
        }
        
        var quotePrice: Double? {
            return Double(realmQuote.price)
        }
        cell.quotePriceLabel.text = "$ " + String(format: "%.4f", quotePrice!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? QuoteTableViewCell
        let indexPath = tableView.indexPath(for: cell!)
        let quote = modelData[indexPath!.row]
        
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
            if self.modelData == [] {
                self.saveToRealm()
            } else if self.isRealmDataDeleted == true {
                self.saveToRealm()
            }
            self.readQuotes()
            self.hud.dismiss()
            self.tableView.reloadData()
        }
    }
}
