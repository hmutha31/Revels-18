//
//  ScheduleCollectionViewCell.swift
//  Revels-18
//
//  Created by Shreyas Aiyar on 19/01/18.
//  Copyright © 2018 Shreyas Aiyar. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var eventName: UILabel!
  @IBOutlet weak var time: UILabel!
  @IBOutlet weak var location: UILabel!
  @IBOutlet weak var favouriteButton: UIButton!
  @IBOutlet weak var categoryImage: UIImageView!
  var eid:String?
  let color:UIColor = UIColor(displayP3Red: 181/255, green: 28/255, blue: 18/255, alpha: 1)
  
  var delegate:AddToFavoritesProtocol!

  override func awakeFromNib() {
    let highlightedImage = UIImage(named: "BlurFavorites")
    favouriteButton.setImage(highlightedImage, for: .selected)
    location.layer.cornerRadius = 2
    location.clipsToBounds = true
    layer.cornerRadius = 10
    categoryImage.layer.cornerRadius = categoryImage.bounds.height/2
    categoryImage.layer.borderWidth = 0.5
    categoryImage.layer.borderColor = UIColor.gray.cgColor
    categoryImage.layer.masksToBounds = true
  }
  
  @IBAction func didSelectFavoritesButton(_ sender: UIButton) {
    favouriteButton.pulse()
    if favouriteButton.isSelected == true{
      print("Selected")
      favouriteButton.isSelected = false
      self.delegate.removeFromFavorites(eid: self.eid!)
    }
    else{
      print("Not Selected")
      favouriteButton.isSelected = true
      self.delegate.addToFavorites(eid: self.eid!)
    }
  }
  
}

protocol AddToFavoritesProtocol{
  func addToFavorites(eid:String)
  func removeFromFavorites(eid:String)
}
