//
//  QuoteCachedProvider.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 5/10/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation
import RealmSwift

class QuoteCachedProvider {
    
    func readQuotes()-> [Quote]? {
        do {
            let realm = try Realm()
            return realm
                .objects(QuoteCached.self)
                .map{Quote(quoteCached: $0)}
        } catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
        return nil
    }
       
    func saveAndUpdateQuotes(quotes: [Quote]) {
         let realm = try! Realm()
            do {
                try realm.write {
                    quotes
                        .map{QuoteCached(quote: $0)}
                        .forEach{ quote in
                            realm.add(quote, update: .modified)
                        }
                }
            } catch {
                print("ERROR: \(error)")
            }
    }
}
