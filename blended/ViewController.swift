//
//  ViewController.swift
//  blended
//
//  Created by Adrian Ortuzar on 16/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var emptySearchLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var items : [[String:AnyObject]] = []
    
    var isSearching : Bool = false
    
    var hideFooter : Bool = false
    
    let reuseIdentifier = "cell"
    
    var dataService : DataService?
    
    init(tag: String){
        
        super.init(nibName: "ViewController", bundle: nil)
        
        self.dataService = DataService.init(tag: tag)
        
        self.title = {
            return (tag.isEmpty) ? "Products" : tag
        }()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.emptySearchLabel.isHidden = true
        
        self.requestApi()
        
        self.searchBar.delegate = self
        
        // register cell
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // register footer
        self.collectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier:"footerCell")
        
        self.collectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: "footerCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var requestInProgress : Bool = false
    
    var skyp : Int = 0
    
    func requestApi() {
        
        if (self.isSearching) {
            return
        }
        
        self.dataService!.getData() {
            // hide loading if there is no more products
            if  self.dataService!.items.count < 10 {
                self.hideFooter = true
            }
            
            // set collectionview
            self.items = self.dataService!.items
            self.collectionView.reloadData()
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

    
    func CollectionViewDidFinishScroll() {
        self.requestApi()
    }
    
    func CollectionViewDidSelectTag(tagName: String){
        if  tagName != self.dataService!.tag {
            
            let vc = ViewController.init(tag: tagName)
            let navigationController =  UIApplication.shared.windows[0].rootViewController as! UINavigationController
            
            if  self.dataService!.tag!.isEmpty {
                
                navigationController.pushViewController(vc, animated: true)
            }
            else {
                navigationController.popToRootViewController(animated: false)
                navigationController.pushViewController(vc, animated: true)
            }
            
        }
        
    }
}

// MARK: UICollectionViewDataSource

extension ViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell : CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        let item : [String: AnyObject] = self.items[indexPath.row]
        
        cell.setup(dictionary: item)
        
        cell.collectionViewCellDelegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate protocol

extension ViewController : UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetY = scrollView.contentOffset.y
        if (offsetY > height){
            // finish scroll
            self.CollectionViewDidFinishScroll()
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
        return CGSize.init(width: self.collectionView.frame.size.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath:NSIndexPath) -> CGSize
    {
        return CGSize.init(width: self.collectionView.frame.size.width, height: 200)
    }
    
}


// MARK: UISearch delegate

extension ViewController : UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText.isEmpty){
            self.searchBarTextDidEndEditing(searchBar)
            return
        }
        
        self.isSearching = true
        self.hideFooter = true
        
        let reslt = self.dataService!.items.filter {
            let str : String = $0["face"] as! String
            return str.contains(searchText)
        }
        
        self.emptySearchLabel.isHidden = (reslt.count == 0) ? false : true
        
        self.items = reslt
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
        
        self.emptySearchLabel.isHidden = true
        
        //
        self.items = self.dataService!.items
        self.collectionView.reloadData()
        self.hideFooter = false
    }
}

extension ViewController : CollectionViewCellDelegate {
    
    func CollectionViewCellDidSelectTag(tagName: String){
        self.CollectionViewDidSelectTag(tagName: tagName)
    }
}
