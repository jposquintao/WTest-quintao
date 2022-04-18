//
//  Article.swift
//  WTest
//
//  Created by João Quintão on 17/04/2022.
//

import Foundation

typealias Articles = [Article]

class Article{
    var id:String
    var title:String
    var publishedDate:Date
    var hero:String?
    var author:String
    var summary:String?
    var body:String
    
    init(_id:String, _title:String, _publishedDate:Date, _hero:String, _author:String, _summary:String, _body:String){
        self.id = _id
        self.title = _title
        self.publishedDate = _publishedDate
        self.hero = _hero
        self.author = _author
        self.summary = _summary
        self.body = _body
    }
    
    
    // PARSE Json from the web request and init a new Article
    init?(json:[String:AnyObject]){
        if let value = json["id"] as? String{
            self.id = value
        }else{
            return nil
        }
        
        if let value = json["title"] as? String{
            self.title = value
        }else{
            return nil
        }
        
        if let value = json["published-at"] as? String{
            let auxarray = value.components(separatedBy: "+")
            let stringdate = !auxarray.isEmpty ? auxarray[0] : ""
            self.publishedDate = Utils.convertStringToDate("yyyy-MM-dd'T'HH:mm:ss", stringDate: stringdate)
        }else{
            return nil
        }
        
        if let value = json["hero"] as? String{
            self.hero = value
        }
        
        if let value = json["author"] as? String{
            self.author = value
        }else{
            return nil
        }
        
        if let value = json["summary"] as? String{
            self.summary = value
        }
        
        if let value = json["body"] as? String{
            self.body = value
        }else{
            return nil
        }
    }
}
