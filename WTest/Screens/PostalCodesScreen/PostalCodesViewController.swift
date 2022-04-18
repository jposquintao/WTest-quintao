//
//  ViewController.swift
//  WTest
//
//  Created by João Quintão on 15/04/2022.
//

import UIKit
import SwiftCSV
import CoreData

class PostalCodesViewController: KeyboardTableViewController {

    @IBOutlet weak var loadFile: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoResults: UILabel!
    
    private var isLoding:Bool = false
    private var listEmpty:Bool = false
    private var lastContentOffset: CGFloat = 0
    
    private var offset:Int = 0
    
    lazy var viewModel = {
        PostalViewModal()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerCells()
        
        self.auxTableView = tableView
        self.searchBar.delegate = self
        self.searchBar.endEditing(true)
        
        initViewModel {}
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initViewModel(completion: @escaping () -> Void) {
        // Get postalCode data
        viewModel.fetchData(loadActivity: loadFile, offset: offset)
        
        // Reload TableView closure
        viewModel.didReloadData = { [weak self] in
            print("RELOAD DATA")
            self?.isLoding = false
            self?.labelNoResults.isHidden = self?.viewModel.postalCodeCellViewModels.count != 0
            self?.tableView.reloadData()
            self?.loadFile.stopAnimating()
        }
        
        viewModel.didEndParseData = {
            self.viewModel.fetchData(loadActivity: self.loadFile, offset: self.offset)
        }
    }
    
    func registerCells(){
        tableView.register(PostalCodeCell.nib, forCellReuseIdentifier: PostalCodeCell.identifier)
    }
    
    func requestData(offset:Int, searchText:String){
        isLoding = true
        loadFile.isHidden = false
        loadFile.startAnimating()
        viewModel.fetchSearchData(offset: offset, search: searchText, loadActivity: loadFile)
    }
}

extension PostalCodesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postalCodeCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostalCodeCell.identifier, for: indexPath) as? PostalCodeCell else { fatalError("xib does not exists") }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (Int(self.lastContentOffset) < Int(scrollView.contentOffset.y)) {
            let positionAtual:CGFloat = tableView.contentOffset.y
            let contentHeigth:CGFloat = tableView.contentSize.height - tableView.frame.size.height
            
            if Int(contentHeigth) > 0 && Int(positionAtual) >= Int(contentHeigth) && !isLoding{
                self.offset += 20
                requestData(offset: offset, searchText: searchBar.text ?? "")
            }
        }
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
    }
}

extension PostalCodesViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("DID CHANCE \(searchText)")
        self.offset = 0
        tableView.setContentOffset(.zero, animated:false)
        requestData(offset: 0, searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

