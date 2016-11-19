//
//  CollectionView.swift
//  blended
//
//  Created by Adrian Ortuzar on 19/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    let reuseIdentifier = "cell"
    
    public var items : NSMutableArray = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self;
        self.dataSource = self;
        
        
        self.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        // square
        //self.backgroundView?.addSubview(self.loadingView)
    }
    
    lazy var loadingView : UIView = {
        
        let frame : CGRect = CGRect.init(x: self.frame.size.width/2 - 30/2, y: self.frame.height - 10 - 30, width: 30, height: 30)
        let view = UIView.init(frame: frame)
        view.backgroundColor = UIColor.green
        return view
    }()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell : CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        let item : Dictionary <String, AnyObject> = self.items[indexPath.row] as! Dictionary
        
        cell.nameLabel.text = item["face"] as! String
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    var counterDegress : Int = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetY = scrollView.contentOffset.y
        if (offsetY > height){
            // do next call
            //print("AAA")
            print(offsetY - height);            
            
            
            self.counterDegress += 2
            
            UIView.animate(withDuration: 0, animations: {
                let radians : CGFloat = self.degressToRadians(degress: CGFloat(self.counterDegress))
                print(radians)
                
                self.loadingView.transform = CGAffineTransform(rotationAngle: radians)
            })
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if (self.isOutScroll()){
//            print("outscroll")
//            
//            let height = self.collectionView.contentSize.height - self.collectionView.frame.size.height
//            //self.collectionView.contentSize.height = self.collectionView.contentSize.height + 50
//            let point : CGPoint = CGPoint.init(x: self.collectionView.contentOffset.x, y: height + 50)
//            self.collectionView.setContentOffset(point, animated: true)
//            //self.collectionView.setContentOffset(CGPoint(self.collectionView.contentOffset.x, height + 50), animated: true)
//        }
    }
    
    func degressToRadians(degress:CGFloat) -> CGFloat {
        return (degress * .pi)/180
    }
}
