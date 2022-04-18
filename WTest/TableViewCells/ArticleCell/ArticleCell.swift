//
//  ArticleCell.swift
//  WTest
//
//  Created by João Quintão on 17/04/2022.
//

import Foundation
import UIKit

class ArticleCell : UITableViewCell{
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelSumary: UILabel!
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var cellViewModel: ArticleCellViewModal? {
        didSet {
            labelTitle.text = cellViewModel?.title
            labelAuthor.text = cellViewModel?.author
            labelSumary.text = cellViewModel?.summary
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
