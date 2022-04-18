//
//  ArticleViewModal.swift
//  WTest
//
//  Created by João Quintão on 17/04/2022.
//

import Foundation

class ArticleViewModal: NSObject {
    
    var didReloadData: (() -> (Void))?
   
    var articles = Articles()
    
    var articleCellViewModels = [ArticleCellViewModal]() {
        didSet {
            didReloadData?()
        }
    }
    
    // Get articles from the web service
    func getArticles(page:Int) {
        if page == 1{
            articleCellViewModels = []
        }
        RequestHandler.RequestArticles.getArticles(page: page) { articles, status, error in
            if let articles = articles, (status >= 200 || status < 300), error == nil {
                self.fetchData(articles: articles)
            }else{
                print("ERROR")
            }
        }
    }
    
    // Create cellViewModals
    func fetchData(articles: Articles) {
        self.articles = articles
        var vms = [ArticleCellViewModal]()
        for article in articles {
            vms.append(createCellModel(article: article))
        }
        articleCellViewModels.append(contentsOf: vms)
    }
    
    func createCellModel(article: Article) -> ArticleCellViewModal {
        return ArticleCellViewModal(title: article.title, author: article.author, summary: article.summary)
    }

    func getCellViewModel(at indexPath: IndexPath) -> ArticleCellViewModal {
        return articleCellViewModels[indexPath.row]
    }
}
