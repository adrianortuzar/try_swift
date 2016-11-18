//
//  ViewController.swift
//  blended
//
//  Created by Adrian Ortuzar on 16/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var items : NSMutableArray = []
    
    let reuseIdentifier = "cell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        
        
        self.requestApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    var inProgress : Bool = false
    
    var skyp : Int = 0
    
    func requestApi() {
        
        if (self.inProgress) {
            return
        }
        
        self.inProgress = true;
        
        // start
        
        let url : String = "http://74.50.59.155:5000/api/search&skip=\(self.skyp)"
        
        Alamofire.request(url).responseString { response in
            
            let responsstring : String = response.result.value!;
            
            let arr : [String] = responsstring.components(separatedBy: "\n")
            
            for string in arr {
                let dic : NSDictionary = self.stringToJson(string:string) as NSDictionary
                if( dic.allKeys.count != 0 ){
                    self.items.add(dic)
                }
                
            }
            print(self.items)
            self.collectionView.reloadData()
            
            self.skyp = self.skyp + 10
            
            self.inProgress = false;
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
    
    
    @IBAction func buttonaction(_ sender: Any) {
        self.requestApi()
    }
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetY = scrollView.contentOffset.y
        
        //print(offsetY, height)
        if (offsetY > height){
            // do next call
            //print("AAA")
            print(offsetY - height);
//            scrollView.contentSize.height = scrollView.contentSize.height + 10
            
            self.requestApi()
        }
    }
}

