//
//  LogManagerViewController.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/24/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

open class LogViewController: UIViewController {
    
    //MARK:Properties
    @IBOutlet weak var log: UITextView!
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(LogViewController.didUpdateLog(_:)), name: NSNotification.Name(rawValue: LogManager.LogUpdateNotificationKey), object: nil)
        
        self.log.text = LogManager.sharedInstance.logText
        
        self.log.scrollToBotom()
    }
    
    //MARK:Lifcycle
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LogManager.LogUpdateNotificationKey), object: nil)
    }
    
    //MARK:Updateing Log
    @objc open func didUpdateLog (_ notification: Notification) {
        
        let logText = notification.userInfo![LogManager.LogKey] as! String
        
        DispatchQueue.main.async {
            
            self.log.text = logText
            
            self.log.scrollToBotom()
            
        }
        
    }
    
}
