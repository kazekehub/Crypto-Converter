//
//  ShowAlert.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 5/10/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit

extension UIViewController {
    func showSimpleAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
             }))
        self.present(alert, animated: true, completion: nil)
    }
}
