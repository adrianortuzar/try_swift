//
//  CollectionView.swift
//  blended
//
//  Created by Adrian Ortuzar on 19/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit

protocol CollectionViewDelegate{
    func CollectionViewDidFinishScroll(collectionView:CollectionView)
}

class CollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionViewdelegate:CollectionViewDelegate! = nil
    
    let reuseIdentifier = "cell"
    
    public var items : NSMutableArray = []
    
    public var height : CGFloat = 3000.0
    
    public var hideFooter : Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        let refreshControl : UIRefreshControl = UIRefreshControl.init()
//        refreshControl.tintColor = UIColor.purple
        //refreshControl.addTarget(self, action:Selector("refershControlAction"), for:UIControlEventValueChanged)
        //self.addSubview(refreshControl)

        
        self.backgroundColor = UIColor.clear
        
        // register cell
        self.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // register footer
        self.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier:"footerCell")
        
        self.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: "footerCell")
        
        self.delegate = self;
        self.dataSource = self;
        
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
        
        cell.setup(dictionary: item)
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetY = scrollView.contentOffset.y
        if (offsetY > height){
            // finish scroll
            self.collectionViewdelegate!.CollectionViewDidFinishScroll(collectionView: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview : UICollectionReusableView = UICollectionReusableView.init()
        
        if (kind == UICollectionElementKindSectionFooter){
            let footerview : FooterCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerCell", for: indexPath) as! FooterCollectionReusableView
            
            footerview.loadingView.startAnimating()
            
            reusableview = footerview
        }
        
        return reusableview
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForFooterInSection section: Int) -> CGSize
    {
        let height : CGFloat = {
            if self.hideFooter {
                return 0
            }
            else{
                return 50
            }
        }()
        return CGSize.init(width: self.frame.size.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath:NSIndexPath) -> CGSize
    {
        return CGSize.init(width: self.frame.size.width, height: 250)
    }
    
}
