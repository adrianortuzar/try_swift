//
//  FooterCollectionReusableView.swift
//  blended
//
//  Created by Adrian Ortuzar on 20/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
