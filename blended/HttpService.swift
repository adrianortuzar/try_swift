//
//  HttpService.swift
//  blended
//
//  Created by Adrian Ortuzar on 21/12/2016.
//  Copyright © 2016 Adrian Ortuzar. All rights reserved.
//

import Foundation
import Alamofire

struct HttpService {
    
    static func getData(skip: Int, tag: String, _ completion: @escaping (_ items : [[String:AnyObject]]) -> Void) {
        
        let url : String = "http://74.50.59.155:5000/api/search?skip=\(skip)&q=" + tag
        
        Alamofire.request(url).responseString { response in
            
            let responsstring : String = response.result.value!
            if  (responsstring.isEmpty){
                
            }
            
            var arr : [String] = responsstring.components(separatedBy: "\n")
            
            // remove last item if is empty string
            if ( arr.count != 0 && (arr[arr.count - 1] as String).isEmpty ){
                arr.remove(at: arr.count - 1)
            }
            
            
            print(responsstring)
            
            var items : [[String:AnyObject]] = []
            
            for string in arr {
                let dic : [String:AnyObject] = HttpService.stringToJson(string) as [String:AnyObject]
                
                if( dic.keys.count != 0 ){
                    items.append(dic)
                }
            }
            
            completion(items)
        }
    
    }
    
    static func stringToJson(_ string: String) -> Dictionary <String, AnyObject>  {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        do {
            let json : Dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            return json
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            return [:]
        }
    }
}
