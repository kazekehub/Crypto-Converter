//
//  QuoteTableViewController.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/22/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import SVGKit
import SDWebImage
import SDWebImageSVGCoder
import JGProgressHUD
import TableViewReloadAnimation


class QuoteTableViewController: UITableViewController {
    
    var isSelectQuoteMode = false
    var quoteData: [Quote] = []

    let quoteApi = "https://api.nomics.com/v1/currencies/ticker?key=3c8c0907276523d0ff0e94c50657de0c&format=json&convert=USD"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reseiveQuoteNotification),
                                               name: NotificationSendQuoteList,
                                               object: nil)
    }
    @objc func reseiveQuoteNotification(notification: Notification){
        _ = notification.object as? [Quote]
    }
    
    @IBAction func quoteUpdateClick(_ sender: Any) {
        loadJSON()
        tableView.reloadData(with: .simple(duration: 0.75, direction: .rotation3D(type: .spiderMan),
        constantDelay: 0))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJSON()
        tableView.tableFooterView = UIView()
    }
    
    func loadJSON() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)

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
                                hud.dismiss()
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
        return 80
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quoteData.count
    }
     
    func loadPage(_ page: Int) {
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quotesCellId", for: indexPath) as! QuoteTableViewCell
        
        
        let quote = quoteData[indexPath.row]
        
        let imageURL = URL(string: quote.logoUrl!)
        cell.quoteImage.sd_setImage(with:imageURL, placeholderImage:nil)

//        if let svg = URL(string: quote.logoUrl!), let data = try? Data(contentsOf: svg), let receivedimage: SVGKImage = SVGKImage(data: data) {
//            cell.quoteImage.image = receivedimage.uiImage
//        } else {
//            cell.quoteImage?.sd_setImage(with: URL(string:quote.logoUrl!), placeholderImage:nil)
//        }
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


