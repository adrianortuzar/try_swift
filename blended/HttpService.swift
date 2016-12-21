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
    
    static var skyp : Int = 0
    
    static var inProgress : Bool = false
    
    static var items : [[String:AnyObject]] = []
        
    static func getData (withTag tag:String,_ completion: @escaping () -> Void) {
        
        if (HttpService.inProgress) {
            return
        }
        
        HttpService.inProgress = true;
        
        // start
        
        let url : String = "http://74.50.59.155:5000/api/search?skip=\(HttpService.skyp)&q=" + tag
        
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
            
            for string in arr {
                let dic : [String:AnyObject] = HttpService.stringToJson(string) as [String:AnyObject]
                
                if( dic.keys.count != 0 ){
                    HttpService.items.append(dic)
                }
            }
            
            HttpService.skyp = HttpService.skyp + 10
            
            HttpService.inProgress = false;
            
            completion()
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
