//
//  CollectionViewLayout.swift
//  blended
//
//  Created by Adrian Ortuzar on 19/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    
    
    override func prepare() {
        
    }
    
    override var collectionViewContentSize: CGSize {
        
        
        let collection : CollectionView = self.collectionView! as! CollectionView
        return CGSize.init(width: self.collectionView!.frame.size.width, height: collection.height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let att : UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: <#T##IndexPath#>)
//        att.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        return []
    }
}
