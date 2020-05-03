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
    let defaults = UserDefaults.standard
    
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
        tableView.reloadData(with: .simple(duration: 0.75, direction: .rotation3D(type: .doctorStrange),
        constantDelay: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.bool(forKey: "First Laucnh") == true{
            print("already lauched")
            defaults.set(true,forKey: "First Laucnh")
        } else {
            print("First")
            defaults.set(true,forKey: "First Laucnh")
        }
        
        
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
        
        //DAI,XVG,DRGN ->> библиотека не читает svg файлы указанных котировок, поэтому вручную загрузил
        
        switch quote.symbol {
        case "DAI":
            cell.quoteImage.image = (UIImage(named: "DAI"))
        case "XVG":
            cell.quoteImage.image = (UIImage(named: "XVG"))
        case "DRGN":
            cell.quoteImage.image = (UIImage(named: "DRGN"))
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
        
        var quotePrice: Double? {
            return Double(quote.price!)
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}
