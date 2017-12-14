//
//  Extensions.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/10/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import Foundation
import MultipeerConnectivity
#if os(iOS)
import UIKit
#endif


extension MCSessionState:  CustomStringConvertible {
    
    public var description: String {
        switch(self) {
        case .notConnected: return "Not Connected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        }
    }
    
}

#if os(iOS)
extension UIScreen {
    
    class var screenSize: CGSize{
        return UIScreen.main.bounds.size
    }
    
    class var width: CGFloat{
        return UIScreen.screenSize.width
    }
    
    class var height: CGFloat{
        return UIScreen.screenSize.height
    }
    
}

extension UITextView {
    
    func scrollToBotom() {
        let range = NSMakeRange(text.count - 1, 1);
        scrollRangeToVisible(range);
    }
    
}

extension UIImage {
    func imageWithColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
#endif
