//
//  FeedItemTBC.swift
//  Feed
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

import UIKit
import SDWebImage

/*
 The class to manage the item cell.
 */
class FeedItemTBC: UITableViewCell {
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var postLabel: UILabel!
    
    @IBOutlet var contentLabel: UILabel!
    
    @IBOutlet var iconImageView: UIImageView!
    
    // The line in the left.
    @IBOutlet var topVerticalLine: UIView!
    
    @IBOutlet var roundView: UIView!
    
    /*
     Size properties
     */
    // The minimum height of cell
    static let MiniHeight : CGFloat = 140
    // The distance from the margin of cell to the margin of content label.
    static let ContentLabelMarginTop: CGFloat = 40
    static let ContentLabelMarginBotton: CGFloat = 10
    static let ContentLabelMarginLeft: CGFloat = 140
    static let ContentLabelMarginRight: CGFloat = 12

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.roundView.layer.cornerRadius = self.roundView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // Receive data for displaying
    func setItem(item: FeedItem, index: Int) {
        // If the item is the first one, the top vertical line is hidden.
        if index == 0{
            self.topVerticalLine.isHidden = true
        }else{
            self.topVerticalLine.isHidden = false
        }
        
        // displaying data
        if let url = item.getImageUrl(){
            self.iconImageView.sd_setImage(with: url, completed: nil)
        }
        self.contentLabel.text = item.getText()
        self.dateLabel.text = item.getDate()
        self.timeLabel.text = item.getTime()
        // false: Ready-to-post, true: Regular
        self.postLabel.isHidden = item.getReadyStatus()
        
        // Configure the background and text color.
        if item.getReadyStatus() == false{
            self.roundView.backgroundColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 1)
            self.backgroundColor = UIColor.init(red: 0, green: 0.5, blue: 0, alpha: 0.1)
            self.timeLabel.textColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 1)
            self.postLabel.textColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 1)
        }
    }

}
