//
//  ViewController.swift
//  blended
//
//  Created by Adrian Ortuzar on 16/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, CollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var emptySearchLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: CollectionView!
    
    public var tagString : String = ""
    
    public var itemsLoaded : NSMutableArray = []
    
    public var isSearching : Bool = false
    
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
        
        self.emptySearchLabel.isHidden = true
        
        self.requestApi()
        
        self.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var requestInProgress : Bool = false
    
    var skyp : Int = 0
    
    func requestApi() {
        
        if (self.requestInProgress || self.isSearching) {
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
                    self.itemsLoaded.add(dic)
                }
            }
            
            // set collectionview
            self.collectionView.items = self.itemsLoaded;
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
    
    func CollectionViewDidSelectTag(tagName: String){
        if  tagName != self.tagString {
            
            let vc = ViewController.init(tag: tagName)
            let navigationController =  UIApplication.shared.windows[0].rootViewController as! UINavigationController
            
            if  self.tagString.isEmpty {
                
                navigationController.pushViewController(vc, animated: true)
            }
            else {
                navigationController.popToRootViewController(animated: false)
                navigationController.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    
    // MARK: UISearch delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.isEmpty){
            self.searchBarTextDidEndEditing(searchBar)
            return
        }
        
        self.isSearching = true
        self.collectionView.hideFooter = true
        
        let predicate : NSPredicate = NSPredicate(format: "face contains[c] %@", searchText)
        let reslt : [Any] = self.itemsLoaded.filtered(using: predicate)
        
        self.emptySearchLabel.isHidden = (reslt.count == 0) ? false : true
        
        self.collectionView.items = NSMutableArray.init(array: reslt)
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
        
        self.emptySearchLabel.isHidden = true
        
        //
        self.collectionView.items = self.itemsLoaded
        self.collectionView.reloadData()
        self.collectionView.hideFooter = false
    }
    
    
    
}

