//
//  IngredientCell.swift
//  RecipeApp
//
//  Created by Saajith Zain on 11/11/19.
//  Copyright © 2019 Saajith Zain. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {

    @IBOutlet weak var ingredientQtyLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
