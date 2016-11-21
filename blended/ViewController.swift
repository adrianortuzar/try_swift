//
//  ViewController.swift
//  blended
//
//  Created by Adrian Ortuzar on 16/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, CollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: CollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.collectionViewdelegate = self
        
        self.requestApi()
        
        self.title = "Products"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var requestInProgress : Bool = false
    
    var skyp : Int = 0
    
    func requestApi() {
        
        if (self.requestInProgress) {
            return
        }
        
        self.requestInProgress = true;
        
        // start
        
        let url : String = "http://74.50.59.155:5000/api/search&skip=\(self.skyp)"
        
        Alamofire.request(url).responseString { response in
            
            let responsstring : String = response.result.value!
            if  (responsstring.isEmpty){
                
            }
            
            let arr : [String] = responsstring.components(separatedBy: "\n")
            
            print(responsstring)
            
            for string in arr {
                let dic : NSDictionary = self.stringToJson(string:string) as NSDictionary
                if( dic.allKeys.count != 0 ){
                    self.collectionView.items.add(dic)
                }
            }
            
            self.collectionView.reloadData()
            
            self.skyp = self.skyp + 10
            
            self.requestInProgress = false;
    
        }
    }
    
    func stringToJson(string: String) -> Dictionary <String, AnyObject>  {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        do {
            let json : Dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            return json
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            return [:]
        }
    }

    
    func CollectionViewDidFinishScroll(collectionView: CollectionView) {
        self.requestApi()
    }
    
}

