//
//  suggestionsTableCell.swift
//  iosTask
//
//  Created by hashem on 07/08/2021.
//

import UIKit

class suggestionsTableCell: UITableViewCell {
    
    @IBOutlet weak var suggestionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
