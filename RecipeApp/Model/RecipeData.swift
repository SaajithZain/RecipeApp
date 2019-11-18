//
//  RecipeData.swift
//  RecipeApp
//
//  Created by Saajith Zain on 11/10/19.
//  Copyright © 2019 Saajith Zain. All rights reserved.
//

import Foundation

struct RecipeData : Codable{
    
    let imageURL: String
    let name: String
    let ingredients : [Ingredients]
    let steps: [String]
    let timers: [Int]
    
    func getIngredientCount() -> Int {
        return self.ingredients.count
    }
    
    func getTimerTotal() -> Int{
        let total = self.timers.reduce(0, +)
        return total
    }
    
    func getTitleString() -> String {
        return "\(self.name), \(self.getIngredientCount()) Ingredients,  \(self.getTimerTotal()) Minutes"
    }
    
    func getNumberofStepsString() -> String {
        return String(self.steps.count)
    }
    
    // Searched recipes from given string / Searched locally
    static func getSearchedRecipes(_ searchString: String, _ recipeArray:[RecipeData]) -> [RecipeData]{
        

        let lowerCasedSearch = searchString.lowercased()
        let filter = recipeArray.filter { (recipeData) -> Bool in
           
            let ingredientFilter = recipeData.ingredients.filter { (ingredient) -> Bool in
               
                return  ingredient.name.lowercased().contains(lowerCasedSearch)
            }
            
            
            return recipeData.name.lowercased().contains(lowerCasedSearch) || ingredientFilter.count > 0
           
        }
        return filter
    }
}

struct Ingredients : Codable {
    let name: String
    let quantity: String
    let type: String
}
