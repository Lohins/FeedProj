//
//  FeedItem.swift
//  Feed
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

import UIKit

/*
 This class represents the data item in the feed list.
 */
class FeedItem: NSObject {
    
    // The properties for Item object.
    // Note : the value type is optional to handle the failure caused when parsing Json data.
    var imageUrl : String?
    var text: String?
    var isReady: Int?
    var date: Date?
    var timeStamp: Int?
    
    // The height of the table view cell will be calculated based on the text length.
    var cellHeight: CGFloat = 100 // Default
    
    init(data : Dictionary<String, Any>) {
        super.init()
        
        // Parsing Json object.
        
        if let tmpUrl = data["image"] as? String{
            self.imageUrl = tmpUrl
        }
        
        if let tmpText = data["text"] as? String{
            self.text = tmpText
        }
        
        if let tmpIsReady = data["is_ready"] as? Int{
            self.isReady = tmpIsReady
        }
        
        // Convert time stamp to local time.
        if let tmpTimeStamp = data["timestamp"] as? Int{
            let timeInterval = TimeInterval.init(tmpTimeStamp)
            self.timeStamp = tmpTimeStamp
            self.date = Date.init(timeIntervalSince1970: timeInterval)
            
        }
        
        
        // Calculate the height of cell given the long text.
        let appSize = UIScreen.main.bounds.size
        let font = UIFont.systemFont(ofSize: 13)
        let attributes = [NSAttributedStringKey.font: font]
        let bound = String.getBound(text: self.getText(), size: CGSize.init(width: appSize.width - FeedItemTBC.ContentLabelMarginLeft - FeedItemTBC.ContentLabelMarginRight, height: appSize.height), drawOption: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attributes, context: nil)
        
        self.cellHeight = bound.height + FeedItemTBC.ContentLabelMarginTop + FeedItemTBC.ContentLabelMarginBotton
        // If the calculated height is smaller than the minimum height, use the minimum height.
        self.cellHeight = self.cellHeight < FeedItemTBC.MiniHeight ? FeedItemTBC.MiniHeight : self.cellHeight
        
    }
    
    // Setter methods.
    func setDate(date: Date) {
        self.date = date
        self.timeStamp = Int(date.timeIntervalSince1970)
    }
    
    func setText(text: String) {
        self.text = text
    }
    
    // Getter methods.
    func getImageUrl() -> URL? {
        if let urlStr = self.imageUrl, let url = URL.init(string: urlStr){
            return url
        }
        else{
            return nil
        }
    }
    
    func getText() -> String {
        if let text = self.text{
            return text
        }
        else{
            return ""
        }
    }
    
    func getReadyStatus() -> Bool {
        // True for ready to post, false for regular.
        if let status = self.isReady, status == 1{
            return false
        }
        else{
            return true
        }
    }
    
    // Get the time with format - "hour : minute"
    func getTime() -> String {
        guard let date = self.date else {
            return ""
        }
        let dateFormate = DateFormatter.init()
        dateFormate.timeZone = TimeZone.current
        dateFormate.dateFormat = "hh:mm a"
        let time = dateFormate.string(from: date)
        return time
    }
    
    // Get the time with format - "Month Day, Year"
    func getDate() -> String {
        guard let date = self.date else {
            return ""
        }
        let dateFormate = DateFormatter.init()
        dateFormate.timeZone = TimeZone.current
        dateFormate.dateFormat = "MMM dd, yyyy"
        let time = dateFormate.string(from: date)
        
        // Comapre with today
        let today = Date()
        let todayString = dateFormate.string(from: today)
        
        if todayString == time{
            return "Today"
        }
        
        return time
    }
    
    /*
     This function is used to create a deep copy object of itself.
     */
    func deepCopy() -> FeedItem{
        let dict = ["image" : self.imageUrl ?? "", "text": self.text ?? "", "is_ready" : self.isReady ?? 0, "timestamp" : self.timeStamp ?? Date().timeIntervalSince1970] as [String : Any]
        let newItem = FeedItem.init(data: dict)
        
        return newItem
    }
    
}
