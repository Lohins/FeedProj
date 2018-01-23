//
//  FeedTests.swift
//  FeedTests
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

import XCTest
@testable import Feed

class FeedTests: XCTestCase {
    
    var feedItem: FeedItem!
    
    // The fake data
    let FakeData = [
        "image": "https://d1cka1o15bmsqv.cloudfront.net/images/items/25025169_1558912580862270_3222893216390971392_n.jpg",
        "is_ready": 0,
        "text": "From Bill Paxton and Mary Tyler Moore.",
        "timestamp": 1514754215
        ] as [String : Any]
    
    override func setUp() {
        super.setUp()
        
        feedItem = FeedItem.init(data: FakeData)
    }
    
    override func tearDown() {
        // Clear the data to ensure every tests starts with a clean slate.
        feedItem = nil
        
        super.tearDown()
    }
    
    // test setDate()
    func testSetData() {
        feedItem.setDate(date: Date.init())
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "hh MMM dd, yyyy"
        print(dateFormatter.string(from: feedItem.date!))
        
        XCTAssertEqual(dateFormatter.string(from: feedItem.date!), "12 Jan 23, 2018", "Wrong Date.")
    }
    
    // test setText()
    func testSetText(){
        let text = "Hello Kitty"
        
        feedItem.setText(text: text)
        
        XCTAssertEqual(text, feedItem.text!, "Wrong Text")
    }
    
    // test getImageUrl()
    func testGetImageUrl(){
        let urlString = FakeData["image"] as! String
        
        XCTAssert(urlString == feedItem.getImageUrl()!.absoluteString, "Wrong Image Url")
    }
    
    // test getText()
    func testGetText(){
        let text = FakeData["text"] as! String
        XCTAssertEqual(text, feedItem.getText(), "Wrong Text")
    }
    
    // test getReadyStatus()
    func testGetReadyStatus(){
        let status = FakeData["is_ready"] as! Int
        
        XCTAssertEqual(status == 1 ? false : true, feedItem.getReadyStatus(), "Wrong status.")
    }
    
    // test getTime()
    func testGetTime()  {
        let timeStamp = FakeData["timestamp"] as! Int
        let timeInterval = TimeInterval.init(timeStamp)
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = TimeZone.current
        
        XCTAssertEqual(formatter.string(from: date), feedItem.getTime(), "Wrong Time")
    }
    
    // test getDate()
    func testGetDate()  {
        let timeStamp = FakeData["timestamp"] as! Int
        let timeInterval = TimeInterval.init(timeStamp)
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.timeZone = TimeZone.current
        
        XCTAssertEqual(formatter.string(from: date), feedItem.getDate(), "Wrong Time")
    }
    
    // test deepCopy()
    func testDeepCopy() {
        let deepCopy = feedItem.deepCopy()
        
        // If this is a deep copy, then the reference to the internal properties should be different.
        XCTAssert(deepCopy != feedItem, "Shallow Copy.")
    }
    
    
}
