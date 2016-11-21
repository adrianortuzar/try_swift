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
    
    public var tagString : String = ""
    
    init(tag: String){
        
        super.init(nibName: "ViewController", bundle: nil)
        
        self.tagString = tag
        
        self.title = {
            return (tag.isEmpty) ? "Products" : tag
        }()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.collectionViewdelegate = self
        
        self.requestApi()
        
        //self.title = "Products"
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
        
        let url : String = "http://74.50.59.155:5000/api/search?skip=\(self.skyp)&q=" + self.tagString
        
        Alamofire.request(url).responseString { response in
            
            let responsstring : String = response.result.value!
            if  (responsstring.isEmpty){
                
            }
            
            var arr : [String] = responsstring.components(separatedBy: "\n")
            
            // remove last item if is empty string
            if ( arr.count != 0 && (arr[arr.count - 1] as String).isEmpty ){
                arr.remove(at: arr.count - 1)
            }
            
            // hide loading if there is no more products
            if  arr.count < 10 {
                self.collectionView.hideFooter = true
            }
            
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

