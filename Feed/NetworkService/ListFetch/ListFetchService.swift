//
//  ListFetchService.swift
//  Feed
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

import UIKit

class ListFetchService: NSObject {
    
    func fetchList(forPageNum pageNum : Int, finishBlk: @escaping ([FeedItem]?, _ error: Error?) -> Void) {
        
        // Concatenate the request url.
        let url = "http://dev.dashhudson.com/feed_test/next?page=\(pageNum)&token=1laLEqpZ7p"
        
        
        // Do get request.
        FeedBasicNetworkService.sharedInstance.getRequest(url, params: ["data" : "data" as AnyObject]) { (data, err) in
            
            // Ensure the data exists.
            guard let data = data else{
                let err = NSError.init(domain: "Fail to get data", code: 20, userInfo: nil)
                finishBlk(nil, err)
                return
            }
            
            // Check the status code.
            guard let status = data["status"] as? Bool, status == true else{
                let err = NSError.init(domain: "Status error.", code: 20, userInfo: nil)
                finishBlk(nil, err)
                return
            }
            
            // Check the data list.
            guard let list = data["items"] as? [Dictionary<String, Any>] else{
                let err = NSError.init(domain: "Empty data.", code: 20, userInfo: nil)
                finishBlk(nil, err)
                return
            }
            
            // Build the item list
            var itemList: [FeedItem] = []
            for dict in list{
                let item  = FeedItem.init(data: dict)
                itemList.append(item)
            }
            
            // Invoke callback block.
            finishBlk(itemList, nil)
        }
    }

}
