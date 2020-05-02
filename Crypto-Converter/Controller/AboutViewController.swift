//
//  AboutViewController.swift
//  Crypto-Converter
//
//  Created by Beka Zhapparkulov on 4/25/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController,  MFMailComposeViewControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func myEmailButton(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
        let mymail = MFMailComposeViewController()
        mymail.mailComposeDelegate = self
        mymail.setToRecipients(["kzhapparkulov@gmail.com"])
        present(mymail, animated: true)
        } else {
            print("Can not send email")
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    
    @IBAction func goToLinkedinButton(_ sender: Any) {
        guard let url = URL(string: "https://www.linkedin.com/in/kazybek-zhapparkulov/") else { return }
        UIApplication.shared.open(url)
    }
  
    @IBAction func goToWebsiteButton(_ sender: Any) {
        guard let url = URL(string: "https://jumysbar.kz/ios") else { return }
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
}
