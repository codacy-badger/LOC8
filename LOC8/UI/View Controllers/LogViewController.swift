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
        NotificationCenter.default.addObserver(self, selector: #selector(LogViewController.didUpdateLog(_:)), name: Log.LogUpdateNotification, object: nil)
        
        self.log.text = Log.fullLog
        
        self.log.scrollToBotom()
    }
    
    //MARK:Lifcycle
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Log.LogUpdateNotification, object: nil)
    }
    
    //MARK:Updateing Log
    @objc open func didUpdateLog (_ notification: Notification) {
        
        DispatchQueue.main.async {
            
            self.log.text = Log.fullLog
            
            self.log.scrollToBotom()
            
        }
        
    }
    
}
