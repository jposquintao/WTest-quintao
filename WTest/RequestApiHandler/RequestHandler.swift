//
//  RequestHandler.swift
//  WTest
//
//  Created by João Quintão on 17/04/2022.
//

import Foundation
import Alamofire

class RequestHandler{
    
    static var baseURL:String = URLREQUEST.base10.rawValue
    
    static func getHeader() -> HTTPHeaders{
        
        let headers = [HTTPHeader(name: "Content-Type", value: "application/json"),
                       HTTPHeader(name: "Cache-Control", value: "no-cache")
        ]
        
        return HTTPHeaders(headers)
    }
    
    class RequestArticles{
        fileprivate class func _default_ctor(_ json:[String:AnyObject]) -> Article?{
            return Article(json:json)
        }
        
        @discardableResult
        final class func getArticles(page:Int, constructor:@escaping ([String:AnyObject]) -> Article? = RequestArticles._default_ctor, completion:@escaping ([Article]?, Int, Error?) -> ()) -> Request{
            
            let rec = AF.request(baseURL + "?page=\(page)&limit=\(URLLIMIT.limit10.rawValue)", method: .get, encoding:URLEncoding.default, headers: RequestHandler.getHeader())
            
            rec.responseJSON(options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: {
                response in
                
                switch(response.result){
                case let .failure(error):
                    print("FAILURE \(error)")
                    completion(nil, response.response?.statusCode ?? 0, error)
                    
                case let .success(value):
                    print("SUCCESS \(value)")
                    
                    var articles:[Article] = []
                    if let json = value as? [String:AnyObject]{
                        if let data = json["items"] as? [[String:AnyObject]]{
                            for art in data{
                                if let article = constructor(art){
                                    articles.append(article)
                                }
                            }
                        }
                    }
                    completion(articles, response.response?.statusCode ?? 0, nil)
                }
            })
            return rec
        }
    }
}
