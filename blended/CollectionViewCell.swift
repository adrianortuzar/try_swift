//
//  CollectionViewCell.swift
//  blended
//
//  Created by Adrian Ortuzar on 18/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak public var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setup(dictionary: Dictionary<String, AnyObject>) {
        self.nameLabel.text = dictionary["face"] as? String
        
        self.stockLabel.text = "Stock: " + String((dictionary["stock"] as? Int)!)
        self.priceLabel.text = String((dictionary["price"] as? Int)!) + "€"
        self.sizeLabel.text = "Size: " + String((dictionary["size"] as? Int)!)
        
//        self.tagsLabel.text = {
//            var tags : String = ""
//            
//            for tag : String in (dictionary["tags"] as? Array)! {
//                if  (tags.isEmpty){
//                    tags = tag
//                }
//                else {
//                    tags = tags + ", " + tag
//                }
//                
//            }
//            return tags
//        }()
    }
    
    
    func printTags(tags: Array<String>) {
        
    }

}
