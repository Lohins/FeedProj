//
//  FeedBasicNetworkService.swift
//  Feed
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

/*
 This Class provides the basic network service for other classes, including basic get and post requests.
 */

import UIKit
import AFNetworking

/*
 This is a callback closure invoked when getting the response from server.
 */
typealias FinishBlock = (_ result: Dictionary<String, AnyObject>?, _ error: Error?) -> Void

class FeedBasicNetworkService: NSObject {
    
    // Singleton object access.
    static let sharedInstance: FeedBasicNetworkService = FeedBasicNetworkService()
    
    var sessionManager: AFHTTPSessionManager!
    
    override init() {
        super.init()
        
        self.initManager()
    }
    
    
    /*
     This function is used to initialize the session manager and assign proper configuration.
     */
    func initManager(){
        
        self.sessionManager = AFHTTPSessionManager.init()
        
        self.sessionManager.requestSerializer = AFJSONRequestSerializer.init(writingOptions: .init(rawValue: 0))
        
        self.sessionManager.requestSerializer.timeoutInterval = 8
        
        self.sessionManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "content-type")
        
        self.sessionManager.responseSerializer.acceptableContentTypes = NSSet.init(objects: "application/json" , "text/json" , "text/html") as? Set<String>
        
    }
    
    /*
     This function is used to do Get request.
     */
    func getRequest(_ url: String, params: Dictionary<String, AnyObject>, finishBlk:  @escaping FinishBlock) {
        self.sessionManager.get(url, parameters: params, progress: { (progress: Progress) -> Void in
        }, success: { (dataTask, result) -> Void in
            /*
             Actually, Json can be hash map, array or simple objects. We regards it as hash map in default.
             */
            if let jsonDict = result as? Dictionary<String, AnyObject>{
                // Parsing successfully, so return dictionary and error as nil.
                finishBlk(jsonDict , nil)
            }
            else{
                let error = NSError.init(domain: "Network request fail.", code: 20, userInfo: nil)
                finishBlk(nil, error)
            }
            
        },failure: { (dataTask, error) in
            finishBlk(nil, error)
        })
    }
    
    /*
     This function is used to do Post request.
     */
    func postRequest(_ url: String, params: Dictionary<String, AnyObject>, finishBlk:  @escaping FinishBlock) {
        self.sessionManager.post(url, parameters: params, progress: { (progress) in
        }, success: { (dataTask, result) in
            /*
             Actually, Json can be hash map, array or simple objects. We regards it as hash map in default.
             */
            if let jsonDict = result as? Dictionary<String, AnyObject>{
                // Parsing successfully, so return dictionary and error as nil.
                finishBlk(jsonDict , nil)
            }
            else{
                let error = NSError.init(domain: "Network request fail.", code: 20, userInfo: nil)
                finishBlk(nil, error)
            }
            
        }) { (dataTask, error) in
            finishBlk(nil, error)
        }
    }
}
