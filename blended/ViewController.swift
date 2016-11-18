//
//  ViewController.swift
//  blended
//
//  Created by Adrian Ortuzar on 16/11/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.requestApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestApi() {
        Alamofire.request("http://74.50.59.155:5000/api/search").responseString { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            let responsstring : String = response.result.value!;
            //responsstring.components(separatedBy: "");
            let arr : [String] = responsstring.components(separatedBy: "\n")
            let mutArr : NSMutableArray = NSMutableArray.init()
            for stringg in arr {
                let data = stringg.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                do {
                    let json : Dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
                    mutArr.add(json)
                    
                    print(json)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }
            print(mutArr)
            
        }
    }
    
    
    @IBAction func buttonaction(_ sender: Any) {
        self.requestApi()
    }

}

