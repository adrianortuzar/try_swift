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
    
    @IBOutlet weak var tagsContainer: UIView!
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
        
        self.printTags(tags: (dictionary["tags"] as? Array)!)

    }
    
    
    func printTags(tags: Array<String>) {
        // remove all buttons
        let subviews : Array<UIView> = self.tagsContainer.subviews
        for view : UIView in subviews {
            view.removeFromSuperview()
        }
        
        var x : CGFloat = 0
        
        for tag : String in tags {
            //var tagNSString : NSString = tag as NSString
            
            //var originalString: String = "Some text is just here..."
            let myString: NSString = tag as NSString
            let size: CGSize = myString.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)])
            
            //
            let frame : CGRect = CGRect.init(x: x, y: 0, width: size.width, height: self.tagsContainer.frame.size.height)
            x += size.width + 15
            let button : UIButton = UIButton.init(frame: frame)
            button.titleLabel!.font =  UIFont.systemFont(ofSize: 17.0)
            button.setTitle(tag, for: UIControlState.normal)
            button.setTitleColor(UIColor.blue, for: UIControlState.normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            self.tagsContainer.addSubview(button)
        }
    }
    
   
    func buttonAction(sender: UIButton!) {
        let button : UIButton = sender as UIButton
        let tag : String = (button.titleLabel?.text)!
        
        let vc = ViewController.init(tag: tag)
        let navigationController =  UIApplication.shared.windows[0].rootViewController as! UINavigationController
        navigationController.pushViewController(vc, animated: true)
    }

}
