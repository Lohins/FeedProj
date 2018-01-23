//
//  String-Extension.swift
//  Feed
//
//  Created by S.t on 2018/1/22.
//  Copyright © 2018年 S.t. All rights reserved.
//

import Foundation
import UIKit


extension String{
    /*
     Get the frame of string given a fixed size and font.
     */
    static func getBound(text string: String, size: CGSize, drawOption: NSStringDrawingOptions, attributes: [NSAttributedStringKey: AnyObject]?, context: NSStringDrawingContext? ) -> CGRect{
        
        let text: NSString = NSString.init(cString: string.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)!
        
        let bound = text.boundingRect(with: size, options: drawOption, attributes: attributes, context: context)
        
        return bound
    }
}
