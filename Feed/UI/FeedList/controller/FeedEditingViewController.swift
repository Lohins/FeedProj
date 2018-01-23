//
//  FeedAddNewViewController.swift
//  Feed
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding


/*
 The class used to edit the post content.
 */
class FeedEditingViewController: UIViewController {
    
    
    // UI Properties
    @IBOutlet var imageView: UIImageView! // Icon
    
    @IBOutlet var inputTextView: UITextView! // text view
    
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var timeSelectButton: UIButton!
    
    @IBOutlet var contentScrollView: TPKeyboardAvoidingScrollView!
    
    var timeSelectView : FeedTimePickerView! // View for time selection
    
    // Data Properties
    var item: FeedItem!
    
    // Call back method invoked when editing is finished.
    var callBack : ((_ item: FeedItem) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the navigation title.
        self.title = "EDIT POST"
        
        self.initUI()
    }
    
    // Fcuntion to initialize the UI configuration.
    func initUI() {
        self.inputTextView.text = item.getText()
        self.inputTextView.delegate = self
        self.imageView.sd_setImage(with: item.getImageUrl(), completed: nil)
        self.timeSelectButton.setTitle( "\(item.getTime()) \(item.getDate())", for: UIControlState.normal)
        timeSelectView = FeedTimePickerView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        timeSelectView.setDate(date: item.date ?? Date())
        timeSelectView.delegate = self
    }
    
    // Function for data injection.
    func setItem(item: FeedItem){
        self.item = item
    }
    
    // When the save button is clicked, the edited item will be sent back to the parent controller and the current view controller will be dismissed.
    @IBAction func saveAction(_ sender: Any) {
        if let closure = callBack{
            closure(item)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // When time selection button is clicked, the view is shown.
    @IBAction func timeSelectAction(_ sender: Any) {
        
        self.view.addSubview(timeSelectView)
    }
    
    
}

// Implement the FeedTimeSelectDelegate function.
extension FeedEditingViewController: FeedTimeSelectDelegate{
    func callBackWithTime(date: Date) {
        let formatter = DateFormatter.init()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "hh:mm a MMM dd, yyyy"
        self.timeSelectButton.setTitle( formatter.string(from: date), for: UIControlState.normal)
        // Update the date of item.
        self.item.setDate(date: date)
        
    }
}

// Implement the UITextViewDelegate function to listen to the changing of text in text view.
extension FeedEditingViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text{
            self.item.setText(text: text)
        }
    }
    
}

