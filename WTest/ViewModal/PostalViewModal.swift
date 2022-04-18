//
//  PostalModal.swift
//  WTest
//
//  Created by João Quintão on 16/04/2022.
//

import Foundation
import UIKit
import CoreData
import SwiftCSV

class PostalViewModal: NSObject {
    
    var didReloadData: (() -> (Void))?
    var didEndParseData: (() -> (Void))?
   
    var dataCodes = PostalCodes()
    
    var postalCodeCellViewModels = [PostalCodeCellViewModel]() {
        didSet {
            didReloadData?()
        }
    }
    
    func checkIfHaveData()->Bool{
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "data_filled"){
            print("App loaded CSV already")
            return true
        }else{
            return false
        }
    }
    
    func setDataParsed(){
        // Set bool to true in UserDefaults when data was parsed to CoreData
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "data_filled")
    }
    
    func fetchSearchData(offset:Int, search:String, loadActivity:UIActivityIndicatorView){
        // Fetch data from CoreData and perfom in background
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = PersistentManager.shared.context
        privateMOC.perform {
            if let objects = PersistentManager.shared.fetchSearchPostalCodes(offset: offset, seacrh: search){
                DispatchQueue.main.async {
                    if offset == 0{
                        self.postalCodeCellViewModels = []
                    }
                    self.fetchDataModels(postalCodes: objects)
                }
            }
        }
    }
    
    func fetchData(loadActivity:UIActivityIndicatorView, offset:Int){
        // Check if has all data parsed into CoreData
        if checkIfHaveData(){
            // Fetch 20 objects
            if let objects = PersistentManager.shared.fetchAllPostalCodes(offset: offset){
                DispatchQueue.main.async {
                    self.fetchDataModels(postalCodes: objects)
                }
            }
        }else{
            // CHECK if did parse some data from csv but did not finished all
            if PersistentManager.shared.checkIfHaveObjectsSaved(){
                // Clean data from coredata
                PersistentManager.shared.clearData()
                // Makes another csv parse
                parseCSVToCoreData(loadActivity: loadActivity)
            }else{
                // Makes download and csv parse into CoreData
                parseCSVToCoreData(loadActivity: loadActivity)
            }
        }
    }
    
    func fetchDataModels(postalCodes: PostalCodes) {
        self.dataCodes = postalCodes
        var vms = [PostalCodeCellViewModel]()
        for dataCode in postalCodes {
            vms.append(createCellModel(postalCode: dataCode))
        }
        postalCodeCellViewModels.append(contentsOf: vms)
    }
    
    func parseCSVToCoreData(loadActivity:UIActivityIndicatorView){
        // Request Download of csv file and starts parsing when is completed
        Utils.downloadURLCsvFile(url: Utils.urlCSV, loadActivity: loadActivity, completion: { myData in
            do{
                // Uses SwiftCSV pod to convert string to CSV
                let csv:CSV = try CSV(string: myData)
                // Get dic with all rows
                let rows = csv.namedRows
                
                // Creates private NSManagedObjectContext to get rows into CoreData in background
                let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateMOC.automaticallyMergesChangesFromParent = true
                privateMOC.undoManager = nil
                privateMOC.parent = PersistentManager.shared.context
                
                privateMOC.perform {
                    // Splits array to make saves in batchs
                    let array = rows.splitInSubArrays(into: 1000)
                    
                    autoreleasepool {
                        for arrRows in array {
                            autoreleasepool {
                                for row in arrRows{
                                    if let numCod = row["num_cod_postal"], let expCod = row["ext_cod_postal"], let desig = row["desig_postal"]{
                                        PersistentManager.shared.createPostalCode(context: privateMOC, numCode: numCod, extCode: expCod, desig: desig)
                                    }
                                }
                            }
                            // Saves NSManagedObjectContext after each batch is finished
                            do {
                                try privateMOC.save()
                                PersistentManager.shared.context.performAndWait {
                                    do {
                                        try PersistentManager.shared.context.save()
                                    } catch {
                                        fatalError("Failure to save context: \(error)")
                                    }
                                    // Reset NSManagedObjectContext after each batch
                                    PersistentManager.shared.context.reset()
                                }
                            } catch {
                                fatalError("Failure to save context: \(error)")
                            }
                            // Reset NSManagedObjectContext after each batch
                            privateMOC.reset()
                        }
                        
                        self.setDataParsed()
                        DispatchQueue.main.async {
                            self.didEndParseData?()
                        }
                    }
                }
            }catch{
                print("ERROR")
            }
        })
    }
    
    func createCellModel(postalCode: PostalCode) -> PostalCodeCellViewModel {
        return PostalCodeCellViewModel(numCodPostal: postalCode.numCodPostal, extCodPostal: postalCode.extCodPostal, desigPostal: postalCode.desigPostal)
    }

    func getCellViewModel(at indexPath: IndexPath) -> PostalCodeCellViewModel {
        return postalCodeCellViewModels[indexPath.row]
    }
    
}
