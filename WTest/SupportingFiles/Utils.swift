//
//  Utils.swift
//  WTest
//
//  Created by João Quintão on 16/04/2022.
//

import Foundation
import UIKit

class Utils{
    static var urlCSV:String = "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv"
    
    static var limit:Int = 100
    
    static func downloadURLCsvFile(url:String, loadActivity:UIActivityIndicatorView, completion: @escaping (String) -> Void){
        if let url = URL(string: url){
            DispatchQueue.main.async {
                loadActivity.startAnimating()
                loadActivity.isHidden = false
            }
            URLSession.shared.downloadTask(with: url) { (fileUrl, response, error) in
                if let file = fileUrl{
                    do{
                        completion(try String(contentsOf: file))
                    }catch{
                        print("Cannot load contents")
                    }
                }
            }.resume()
            print("LOADING")
        }else{
            print("String was not a URL")
        }
    }
    
    class func convertStringToDate(_ format:String, stringDate:String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        if let date = formatter.date(from: stringDate){
            return date
        }else{
            return Date()
        }
    }
}
