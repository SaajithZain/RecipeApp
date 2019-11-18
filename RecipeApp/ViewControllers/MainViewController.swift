//
//  ViewController.swift
//  RecipeApp
//
//  Created by Saajith Zain on 11/8/19.
//  Copyright © 2019 Saajith Zain. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var recipeManager = RecipeManager()
    var cache: NSCache = NSCache<NSString, NSData>()
    var selectedRecipe: RecipeData?
    var selectRecipeImage: UIImage?
    var recipeCopy:[RecipeData] = []
    var recipeArray : [RecipeData] = []
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeManager.delegate = self
        searchTextField.delegate = self
        recipeManager.getRecipes()
        self.searchView.layer.borderWidth = 0.5
        self.searchView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    
    
    
}

//MARK:- RecipeManagerDelegate

extension MainViewController : RecipeManagerDelegate{
    
    func didReceiveRecipes(_ recipeManager: RecipeManager, _ recipeArray: [RecipeData]) {
        
        self.recipeArray = recipeArray
        self.recipeCopy = recipeArray
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RecipeDetailViewController
        destinationVC.recipe = self.selectedRecipe
        destinationVC.recipeImage = self.selectRecipeImage
    }
    
    
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.recipeCell, for: indexPath) as! RecipeCell
        let currentRecipeObj = recipeArray[indexPath.row]
        
        //resetting to avoid flickering
        collectionCell.recipeImage.image = UIImage(named: "placeholderImage")
        let urlString = self.recipeArray[indexPath.row].imageURL
        
        DispatchQueue.global().async {
            if let imageURL = URL(string: urlString ){
                do{
                    //if there is already a cached image
                    if let cachedImage = self.cache.object(forKey: urlString as NSString){
                        DispatchQueue.main.async {
                            
                            collectionCell.receipeTitleLabel.text = currentRecipeObj.getTitleString()
                            
                            collectionCell.recipeImage.image = UIImage(data: cachedImage as Data)
                        }
                    }else{
                        let data = try Data(contentsOf: imageURL)
                        //caching images
                        self.cache.setObject(data as NSData, forKey: urlString as NSString )
                        //updates UI in the main thread
                        DispatchQueue.main.async {
                            
                            collectionCell.receipeTitleLabel.text = currentRecipeObj.getTitleString()
                            
                            collectionCell.recipeImage.image = UIImage(data: data)
                        }
                    }
                }catch{
                    print(error)
                }
            }
            
        }
        
        return collectionCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: floor( (collectionView.frame.size.width / 2)) - 1, height: floor(collectionView.frame.size.width / 2) - 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedRecipe = recipeArray[indexPath.row]
        self.selectRecipeImage = (collectionView.cellForItem(at: indexPath) as! RecipeCell).recipeImage.image
        performSegue(withIdentifier:Constants.SegueIdentifier.recipeViewSegue, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
            
        }
    }
}


extension MainViewController: UISearchTextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text, text.isEmpty {
            searchTextField.resignFirstResponder()
            self.recipeArray = recipeCopy
            self.collectionView.reloadData()
            //recipeManager.getRecipes()
            
        }
        else if let searchText = textField.text{
            print((RecipeData.getSearchedRecipes(searchText, self.recipeArray)).count)
            self.recipeArray = RecipeData.getSearchedRecipes(searchText, self.recipeCopy)
            self.collectionView.reloadData()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                if textField.text!.count <= 1{
                    textField.text = ""
                    textField.endEditing(true)
               }
            }
        }
        
        return true
    }
}
