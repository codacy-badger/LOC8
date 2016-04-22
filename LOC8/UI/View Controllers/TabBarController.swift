//
//  TabBarController.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/25/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit
import MultipeerConnectivity

public struct TabBarItemColor {
    
    public static let Normal = UIColor.whiteColor()
    
    public static let Selected = UIColor.blackColor()
    
    public static let Colors = [
        UIColor(red:0.69, green:0.69, blue:0.69, alpha:1),
        UIColor(red:0.58, green:0.77, blue:0.27, alpha:1),
        UIColor(red:0.02, green:0.48, blue:1.00, alpha:1),
        UIColor(red:0.90, green:0.18, blue:0.14, alpha:1),
        UIColor(red:0.50, green:0.00, blue:0.50, alpha:1),
        UIColor(red:0.99, green:0.75, blue:0.00, alpha:1)
    ]
}

public class TabBarController : UITabBarController, UITabBarControllerDelegate {
    
    //MARK:Properties
    private var navigationBar: UINavigationBar { return self.navigationController!.navigationBar }
    
    private var timer: NSTimer?
    
    public var peer: MCPeerID?
    
    //MARK:Lifcycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(TabBarItemColor.Normal).imageWithRenderingMode(.AlwaysOriginal)
                item.selectedImage = image.imageWithColor(TabBarItemColor.Selected).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        
        let attributs = [NSFontAttributeName: UIFont.systemFontOfSize(20), NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = attributs
        UINavigationBar.appearance().titleTextAttributes = attributs
        
        if let map = self.viewControllers?[0] {
            self.tabBarController(self, didSelectViewController: map)
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarController.didReceiveInvetation(_:)), name: MultipeerManagerKeys.ReceivedInvitation, object: nil)
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MultipeerManagerKeys.FoundPeer, object: nil)
    }
    
    
    public func didReceiveInvetation(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let peer = userInfo[MultipeerManagerKeys.PeerId] as! MCPeerID
        
        let alert = UIAlertController(title: "", message: "\(peer.displayName) wants to connect with you.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            MultipeerManager.sharedInstance.invitationHandler?(true, MultipeerManager.sharedInstance.session)
            self.peer = peer
        }
        alert.addAction(acceptAction)
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
            MultipeerManager.sharedInstance.invitationHandler?(false, MultipeerManager.sharedInstance.session)
        }
        alert.addAction(declineAction)
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:UITabBarController Delegate
    public func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController){
        self.navigationItem.title = viewController.navigationItem.title
        self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem
        self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem
        
        let data = ["message":viewController.dynamicType.description()]
        if let peer = self.peer {
            MultipeerManager.sharedInstance.sendData(dictionaryWithData: data, toPeer: peer)
        }
        
    }
    
    //MARK:Animations
    public func startAnimation(duration: NSTimeInterval) {
        if timer != nil { stopAnimation() }
        timer = NSTimer.scheduledTimerWithTimeInterval( duration, target: self, selector: #selector(TabBarController.updateColor(_:)), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    public func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    public func setColor(color: UIColor) {
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.BeginFromCurrentState.union(.TransitionCrossDissolve), animations: { () -> Void in
            self.navigationBar.barTintColor = color
            }, completion: nil)
        
        UIView.transitionWithView(tabBar, duration: 1.0, options: UIViewAnimationOptions.BeginFromCurrentState.union(.TransitionCrossDissolve), animations: { () -> Void in
            self.tabBar.barTintColor = color
            }, completion: nil)
    }
    
    internal func updateColor(timer: NSTimer) {
        let colors = TabBarItemColor.Colors
        let color = colors[random() % colors.count]
        self.setColor(color)
    }
}
