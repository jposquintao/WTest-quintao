//
//  PresistentManager.swift
//  WTest
//
//  Created by João Quintão on 15/04/2022.
//

import Foundation
import CoreData
import UIKit

final class PersistentManager {

    static let shared = PersistentManager()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "WTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: -- DELETE OBJECTS --
        
    //MARK: -- CREATE NEW OBJECTS --
    
    func createPostalCode(context:NSManagedObjectContext, numCode:String, extCode:String, desig:String){
        
        let postalCode = PostalCode(context: context)
        postalCode.numCodPostal = numCode
        postalCode.extCodPostal = extCode
        postalCode.desigPostal = desig
        //saveContext()
    }
    
    //MARK: -- FETCH FROM CORE DATA --
    
    func fetchAllPostalCodes(offset:Int) -> [PostalCode]?{
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PostalCode")
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = 20
        if let fetchResults = (try? context.fetch(fetchRequest)) as? [PostalCode] {
            return fetchResults
        }else{
            return nil
        }
    }
    
    func checkIfHaveObjectsSaved() -> Bool{
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PostalCode")
        fetchRequest.fetchLimit = 1
        if let fetchResults = (try? context.fetch(fetchRequest)) as? [PostalCode] {
            return fetchResults.first != nil
        }else{
            return false
        }
    }
    
    func fetchSearchPostalCodes(offset:Int, seacrh:String) -> [PostalCode]?{
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PostalCode")
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = 20
        if seacrh != ""{
            
            //Split the search string and create the predicates for the fetch
            let mySearch = seacrh.replacingOccurrences(of: "-", with: " ")
            let words = mySearch.components(separatedBy: " ")
            if !words.isEmpty{
                var predicates:[NSPredicate] = []
                for word in words {
                    print("WORD -- \(word)")
                    if word != ""{
                        predicates.append(NSPredicate(format: "desigPostal CONTAINS[cd] %@ OR extCodPostal CONTAINS[cd] %@ OR numCodPostal CONTAINS[cd] %@", word, word, word))
                    }
                }
                let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                fetchRequest.predicate = predicate
            }
        }
        if let fetchResults = (try? context.fetch(fetchRequest)) as? [PostalCode] {
            return fetchResults
        }else{
            return nil
        }
    }
    
    func clearData() {
        do {
            let context = context
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostalCode")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}
