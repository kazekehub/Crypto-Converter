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
          deleteQuote()
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
//        readQuotes()
//        tableView.reloadData()
        
    }
    
    func readQuotes() {
        do {
           let realm = try! Realm()
            let result = try realm.objects(QuoteCached.self)
            result.forEach { quote in
                modelData.append(quote)
            }
        } catch {
            print("error \(error)")
        }
    }
    
    func deleteQuote() {
        do {
            let realm = try! Realm()
            try! realm.write{
                realm.deleteAll()
                self.modelData.removeAll()
            }
            provider = QuoteProvider(delegate: self)
            provider?.requestQuotes()
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
        if modelData.isEmpty == true{
            saveToRealm()
        }
        DispatchQueue.main.async {
            self.readQuotes()
            self.tableView.reloadData()
        }
        
    }
}
