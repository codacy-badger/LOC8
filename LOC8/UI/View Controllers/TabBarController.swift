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
    
    public static let Normal = UIColor.white
    
    public static let Selected = UIColor.black
    
    public static let Colors = [
        UIColor(red:0.69, green:0.69, blue:0.69, alpha:1),
        UIColor(red:0.58, green:0.77, blue:0.27, alpha:1),
        UIColor(red:0.02, green:0.48, blue:1.00, alpha:1),
        UIColor(red:0.90, green:0.18, blue:0.14, alpha:1),
        UIColor(red:0.50, green:0.00, blue:0.50, alpha:1),
        UIColor(red:0.99, green:0.75, blue:0.00, alpha:1)
    ]
}

open class TabBarController : UITabBarController, UITabBarControllerDelegate {
    
    // MARK: Properties
    fileprivate var navigationBar: UINavigationBar {
        return self.navigationController!.navigationBar
    }
    
    fileprivate var timer: Timer?
    
    open var peer: MCPeerID?
    
    // MARK: Lifcycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(TabBarItemColor.Normal).withRenderingMode(.alwaysOriginal)
                item.selectedImage = image.imageWithColor(TabBarItemColor.Selected).withRenderingMode(.alwaysOriginal)
            }
        }
        
        let attributs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController!.navigationBar.titleTextAttributes = attributs
        UINavigationBar.appearance().titleTextAttributes = attributs
        
        if let map = self.viewControllers?[0] {
            self.tabBarController(self, didSelect: map)
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarController.didReceiveInvetation(_:)), name: MultipeerManager.ReceivedInvitationNotification, object: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: MultipeerManager.FoundPeerNotification, object: nil)
    }
    
    
    @objc open func didReceiveInvetation(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        
        let peer = userInfo[MultipeerManagerKeys.PeerId] as! MCPeerID
        
        let alert = UIAlertController(title: "", message: "\(peer.displayName) wants to connect with you.", preferredStyle: UIAlertController.Style.alert)
        
        let acceptAction: UIAlertAction = UIAlertAction(title: "Accept", style: UIAlertAction.Style.default) { (alertAction) -> Void in
            MultipeerManager.shared.invitationHandler?(true, MultipeerManager.shared.session)
            self.peer = peer
        }
        alert.addAction(acceptAction)
        
        let declineAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (alertAction) -> Void in
            MultipeerManager.shared.invitationHandler?(false, MultipeerManager.shared.session)
        }
        alert.addAction(declineAction)
        
        OperationQueue.main.addOperation { () -> Void in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: UITabBarController Delegate
    open func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.navigationItem.title = viewController.navigationItem.title
        self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem
        self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem
        
        let data = ["message":type(of: viewController).description()]
        if let peer = self.peer {
            let _ = MultipeerManager.shared.sendData(dictionaryWithData: data, toPeer: peer)
        }
        
    }
    
    // MARK: Animations
    open func startAnimation(_ duration: TimeInterval) {
        if timer != nil {
            stopAnimation()
        }
        timer = Timer.scheduledTimer( timeInterval: duration, target: self, selector: #selector(TabBarController.updateColor(_:)), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    open func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    open func setColor(_ color: UIColor) {
        
//        UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState.union(.transitionCrossDissolve), animations: { () -> Void in
//            self.navigationBar.barTintColor = color
//            }, completion: nil)
        
        UIView.transition(with: tabBar, duration: 1.0, options: UIView.AnimationOptions.beginFromCurrentState.union(.transitionCrossDissolve), animations: { () -> Void in
            self.tabBar.barTintColor = color
            }, completion: nil)
        
        UIView.transition(with: navigationBar, duration: 1.0, options: UIView.AnimationOptions.beginFromCurrentState.union(.transitionCrossDissolve), animations: { () -> Void in
            self.navigationBar.barTintColor = color
        }, completion: nil)
    }
    
    @objc internal func updateColor(_ timer: Timer) {
        let colors = TabBarItemColor.Colors
        let color = colors[Int(arc4random()) % colors.count]
        self.setColor(color)
    }
}
