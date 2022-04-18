//
//  SelectViewController.swift
//  WTest
//
//  Created by João Quintão on 17/04/2022.
//

import Foundation
import UIKit

class ArticleViewController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    
    private var isLoding:Bool = false
    private var listEmpty:Bool = false
    private var lastContentOffset: CGFloat = 0
    private var page:Int = 1
    
    private var selectedURL:Int = 0
    
    lazy var viewModel = {
        ArticleViewModal()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        initViewModel {}
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onChangeURLPressed(_ sender: Any) {
        
        // Change the URL request and make request to WebService
        RequestHandler.baseURL = (RequestHandler.baseURL == URLREQUEST.base10.rawValue) ? URLREQUEST.base11.rawValue : URLREQUEST.base10.rawValue
        page = 1
        requestData(page: page)
    }
    
    func initViewModel(completion: @escaping () -> Void) {
        // Get articles data
        requestData(page: page)
        
        // Reload TableView closure
        viewModel.didReloadData = { [weak self] in
            print("RELOAD DATA")
            self?.isLoding = false
            self?.loadActivity.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    func registerCells(){
        tableView.register(ArticleCell.nib, forCellReuseIdentifier: ArticleCell.identifier)
    }
    
    func requestData(page:Int){
        isLoding = true
        loadActivity.isHidden = false
        loadActivity.startAnimating()
        viewModel.getArticles(page: page)
    }
}

extension ArticleViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articleCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (Int(self.lastContentOffset) < Int(scrollView.contentOffset.y)) {
            let positionAtual:CGFloat = tableView.contentOffset.y
            let contentHeigth:CGFloat = tableView.contentSize.height - tableView.frame.size.height
            
            if Int(contentHeigth) > 0 && Int(positionAtual) >= Int(contentHeigth) && !isLoding && !listEmpty{
                self.page += 1
                requestData(page: page)
            }
        }
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
}
