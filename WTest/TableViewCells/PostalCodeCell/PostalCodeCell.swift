//
//  PostalCodeCell.swift
//  WTest
//
//  Created by João Quintão on 16/04/2022.
//

import Foundation
import UIKit

class PostalCodeCell : UITableViewCell{
    
    @IBOutlet weak var labelPostalCode: UILabel!
    @IBOutlet weak var labelDesign: UILabel!
    
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    var cellViewModel: PostalCodeCellViewModel? {
        didSet {
            labelPostalCode.text = (cellViewModel?.numCodPostal ?? "####") + "-" + (cellViewModel?.extCodPostal ?? "###")
            labelDesign.text = cellViewModel?.desigPostal
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
