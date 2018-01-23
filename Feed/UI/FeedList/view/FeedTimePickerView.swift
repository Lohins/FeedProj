//
//  FeedTimePickerView.swift
//  Feed
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

import UIKit


// Define delegate
protocol FeedTimeSelectDelegate {
    func callBackWithTime(date: Date)
}

// View Class to present date picker to user.
class FeedTimePickerView: UIView {

    var datePicker: UIDatePicker
    
    
    var delegate: FeedTimeSelectDelegate?
    
    override init(frame: CGRect) {
        let pickerHeight: CGFloat = 200
        self.datePicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: frame.height - pickerHeight, width: frame.width, height: pickerHeight))
        super.init(frame: frame)
        
        self.initUI()

    }
    func setDate(date: Date)  {
        self.datePicker.date = date
    }
    
    func initUI(){
        // dismissButton cover the whole view, and it will dismiss when clicked.
        let dismissButton = UIButton.init(frame: self.frame)
        dismissButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        dismissButton.addTarget(self, action: #selector(dismissSelfFromSuperView), for: .touchUpInside)
        self.addSubview(dismissButton)
        
        // set the date picker.
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.backgroundColor = UIColor.white
        self.addSubview(self.datePicker)
    }
    
    // remove the date picker view from the parent view. Hidden
    @objc func dismissSelfFromSuperView() {
        let newDate = self.datePicker.date
        
        // Invoke the callback function.
        if let delegate = self.delegate{
            delegate.callBackWithTime(date: newDate)
        }
        
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
