//
//  RecipeManager.swift
//  RecipeApp
//
//  Created by Saajith Zain on 11/10/19.
//  Copyright © 2019 Saajith Zain. All rights reserved.
//

import Foundation

protocol RecipeManagerDelegate{
    func didReceiveRecipes(_ recipeManager: RecipeManager, _ recipeArray: [RecipeData])
    func didFailWithError(_ error: Error)
}
struct RecipeManager{
    

    var delegate: RecipeManagerDelegate?
    let url = Constants.Api.recipeUrl
    
    func getRecipes()  {
        if  let recipeUrl = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: recipeUrl) { (data, response, error) in
                if let e = error{
                    print(e)
                }
                if let safeData = data{
                self.parseRecipeJSON(safeData)
                }
            }
            task.resume()
        }
    }
    
    
    func parseRecipeJSON(_ data: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode([RecipeData].self, from: data)
            self.delegate?.didReceiveRecipes(self, decodedData)
           
            
        }catch {
            print(error)
        }
        
    }
    
    
}
