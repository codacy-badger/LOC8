//
//  LogManagerViewController.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/24/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

public class LogViewController: UIViewController {
    
    //MARK:Properties
    @IBOutlet weak var log: UITextView!
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LogViewController.didUpdateLog(_:)), name: LogManager.LogUpdateNotificationKey, object: nil)
        
        self.log.text = LogManager.sharedInstance.logText
        
        self.log.scrollToBotom()
    }
    
    //MARK:Lifcycle
    override public func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: LogManager.LogUpdateNotificationKey, object: nil)
    }
    
    //MARK:Updateing Log
    public func didUpdateLog (notification: NSNotification) {
        
        let logText = notification.userInfo![LogManager.LogKey] as! String
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.log.text = logText
            
            self.log.scrollToBotom()
            
        }
        
    }
    
}