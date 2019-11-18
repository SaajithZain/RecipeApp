//
//  RecipeDetail.swift
//  RecipeApp
//
//  Created by Saajith Zain on 11/11/19.
//  Copyright © 2019 Saajith Zain. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var recipe: RecipeData?
    var recipeImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
//
//
extension RecipeDetailViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return recipe?.ingredients.count ?? 0
        case 3:
            return recipe?.timers.count ?? 0
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.recipeImageCell, for: indexPath) as! RecipeImageCell
            cell.recipeImageView.image = self.recipeImage
            return cell
        }else if(indexPath.section == 1){
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "defaultIdentifier")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = recipe?.name
            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return cell
        }
        else if indexPath.section == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.ingredientCell, for: indexPath) as! IngredientCell
            cell.ingredientLabel.text = self.recipe?.ingredients[indexPath.row].name
            cell.ingredientQtyLabel.text = self.recipe?.ingredients[indexPath.row].quantity
            return cell
            
        }else{
            let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
            let stepString = "Step \(indexPath.row + 1) :"
            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            let attributedString = NSMutableAttributedString(string:stepString, attributes:attrs)
            let step = self.recipe?.steps[indexPath.row]
            let attributedStep = NSMutableAttributedString(string: step!)
            attributedString.append(attributedStep)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.attributedText = attributedString
            cell.isUserInteractionEnabled = false
            return cell
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return ""
        case 2:
            return "\(recipe!.getIngredientCount()) \(Constants.ingredients)"
        case 3:
            return " \(recipe!.getNumberofStepsString()) \(Constants.steps)"
        default:
            return ""
        }
    }
   
    
    
}


