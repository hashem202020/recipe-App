//
//  filterCollectionCell.swift
//  iosTask
//
//  Created by apple on 8/4/21.
//

import UIKit

class filterCollectionCell: UICollectionViewCell {
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var selectionFlag: Bool?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uiHandler()
    }
    
    //MARK:- UIHandler
    /// this function handles the UI Items
    func uiHandler(){
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.cornerRadius = 12
    }
    
    

}
