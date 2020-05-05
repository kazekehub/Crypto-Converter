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
    var isFirstLaunch = false
    
    var modelData: [QuoteCached] = []
    var priceModelChange: [QuoteChanged] = []
    
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
//          deleteQuote()
            quoteData = quotes
            tableView.reloadData()
        }
    }
    
    @IBAction func quoteUpdateClick(_ sender: Any) {
        provider?.requestQuotes()
        tableView.reloadData(with: .simple(duration: 0.75, direction: .rotation3D(type: .doctorStrange),
        constantDelay: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
        }
        
        
        if defaults.bool(forKey: "First Laucnh") == true{
            readQuotes()
            isFirstLaunch = false
            print("already lauched")
            defaults.set(true,forKey: "First Laucnh")
        } else {
            isFirstLaunch = true
            provider = QuoteProvider(delegate: self)
            provider?.requestQuotes()
            
            let hud = JGProgressHUD(style: .dark)
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 6.0)
    
            print("First")
            defaults.set(true,forKey: "First Laucnh")
        }
    }
    
    func saveQuotesToRealm(quote: QuoteCached, price: QuoteChanged) {
       let realm = try! Realm()
        do {
            try realm.write {
                realm.add(quote)
                realm.add(price)
            }
        } catch {
            print("Failed to save quotes. \(error)")
        }
    }
    
//   func savePriceChangedToRealm(price: QuoteChanged){
//          let realm = try! Realm()
//              do {
//                  try realm.write {
//                      realm.add(price)
//                  }
//              } catch {
//                  print("Failed to save price changing. \(error)")
//              }
//          }
//      }
    
    func saveToRealm() {
        for quote in quoteData {
            let modelData = QuoteCached()
            let priceModelChanged = QuoteChanged()
            
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
            
            priceModelChanged.priceChange = quote.oneDay?.priceChange ?? ""
            priceModelChanged.priceChangePct = quote.oneDay?.priceChangePct ?? ""
            priceModelChanged.volume = quote.oneDay?.volume ?? ""
            priceModelChanged.volumeChange = quote.oneDay?.volumeChange ?? ""
            priceModelChanged.volumeChangePct = quote.oneDay?.volumeChangePct ?? ""
            priceModelChanged.marketCapChange = quote.oneDay?.marketCapChange ?? ""
            priceModelChanged.marketCapChangePct = quote.oneDay?.marketCapChangePct ?? ""
           
            saveQuotesToRealm(quote: modelData, price: priceModelChanged)
        }
//        tableView.reloadData()
        
    }
    
    func readQuotes() {
       let realm = try! Realm()
        let result = try realm.objects(QuoteCached.self)
        let result2 = try realm.objects(QuoteChanged.self)
        result.forEach {
            quote in modelData.append(quote)
        }
        result2.forEach{
            quote in priceModelChange.append(quote)
        }
    }
    
    func deleteQuote() {
        let realm = try! Realm()
        try! realm.write{
            realm.delete(realm.objects(QuoteCached.self))
        }
        saveToRealm()
    }
     
    func updateQuotesRealm() {
        let realm = try! Realm()
        do {
            try realm.write {
            realm.autorefresh
//               realm.add(quote, update: .all)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isFirstLaunch == true {
//            return quoteData.count
//        } else {
        return modelData.count
//        return priceModelChanged
//        }
        
    }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCellId", for: indexPath) as! QuoteTableViewCell
        
        //DAI,XVG,DRGN ->> библиотека не читает svg файлы указанных котировок, поэтому вручную загрузил
        
//
//        if isFirstLaunch == true {
//            let quote = quoteData[indexPath.row]
//
//            let imageURL = URL(string: quote.logoUrl!)
//            switch quote.symbol {
//            case "DAI":
//                cell.quoteImage.image = (UIImage(named: "DAI"))
//            case "XVG":
//                cell.quoteImage.image = (UIImage(named: "XVG"))
//            case "DRGN":
//                cell.quoteImage.image = (UIImage(named: "DRGN"))
//            default:
//                cell.quoteImage.sd_setImage(with:imageURL, placeholderImage: UIImage(named: "placeholder"))
//            }
//
//            cell.quotePriceChangeLabel.text = quote.oneDay?.priceChangePct
//            if quote.oneDay?.priceChangePct?.contains("-") == true {
//                    cell.quotePriceChangeLabel.textColor = .red
//                } else {
//                    cell.quotePriceChangeLabel.textColor = .systemGreen
//                }
//            cell.quoteRankLabel.text = quote.rank
//            cell.quoteSymbolLabel.text = quote.symbol
//            cell.quoteNameLabel.text = quote.name
//
//            var quotePrice: Double? {
//                return Double(quote.price!)
//            }
//
//            cell.quotePriceLabel.text = "$ " + String(format: "%.4f", quotePrice!)
//
//        } else {
            let realmQuote = modelData[indexPath.row]
            let realmPriceChanged = realmQuote.oneDay[indexPath.row]
        
            let imageURL = URL(string: realmQuote.logoUrl)
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
            
        cell.quotePriceChangeLabel.text = realmPriceChanged.priceChangePct
        if realmPriceChanged.priceChangePct.contains("-") == true {
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
        readQuotes()
        if modelData.isEmpty == true{
            saveToRealm()
//            updateQuotesRealm()
        } else {
            
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}
