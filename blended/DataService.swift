//
//  DataService.swift
//  blended
//
//  Created by Adrian Ortuzar on 21/12/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import Foundation

class DataService {
    
    var skyp : Int = 0
    
    var inProgress : Bool = false
    
    var items : [[String:AnyObject]] = []
    
    let tag : String?
    
    init(tag: String) {
        self.tag = tag
    }
    
    func getData (_ completion: @escaping () -> Void) {
        
        if (self.inProgress) {
            return
        }
        
        self.inProgress = true;
        
        // start
        HttpService.getData(skip: self.skyp, tag: self.tag!) { items in
            
            self.skyp = self.skyp + 10
            
            self.inProgress = false;
            
            self.items = self.items + items
            
            completion()
        }
    }
    
    
}
