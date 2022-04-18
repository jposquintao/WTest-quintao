//
//  SelectViewController.swift
//  WTest
//
//  Created by João Quintão on 17/04/2022.
//

import Foundation
import UIKit

class SelectViewController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onPostalCodePressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "postalCodeVC") as! PostalCodesViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onArticlesPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "articleVC") as! ArticleViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
