//
//  searchTableCell.swift
//  iosTask
//
//  Created by apple on 8/4/21.
//

import UIKit

class searchTableCell: UITableViewCell {
    
    @IBOutlet weak var recipeImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var healthLabelsCollection: UICollectionView!
    
    var healthLabels : [String] = []
        
        
    override func awakeFromNib() {
        super.awakeFromNib()
        healthLabelsCollection.register(UINib(nibName: healthCellName, bundle: nil), forCellWithReuseIdentifier: healthCellName)
        
        healthLabelsCollection.dataSource = self
        healthLabelsCollection.delegate = self
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}

//MARK:-CollectionView Config
extension searchTableCell: UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return healthLabels.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: healthCellName, for: indexPath) as! healthLabelsCell
        cell.healthLabel.text = healthLabels[indexPath.row]
        return cell
            
    }
    
    
    
}
