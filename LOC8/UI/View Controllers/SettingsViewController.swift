//
//  SettingsViewController.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit
import MultipeerConnectivity

public class settingsViewController: UITableViewController {
    
    //MARK:Properties
    
    @IBOutlet weak var connectionCell: UITableViewCell!
    
    @IBOutlet weak var colorsCell: ColorsTableViewCell!
    
    @IBOutlet weak var animationSwitchCell: SwitchTableViewCell!
    
    @IBOutlet weak var animationDurationAdjustmentCell: AdjustmentTableViewCell!
    
    @IBOutlet weak var generalAdjustmentCell: AdjustmentTableViewCell!
    
    
    @IBOutlet weak var accelerationAdjustmentCell: AdjustmentTableViewCell!
    
    @IBOutlet weak var accelerationFilterTypeCell: FilterTypeTableViewCell!
    
    @IBOutlet weak var accelerationAdaptiveSwitchCell: SwitchTableViewCell!
    
    private var settings: SettingsService {
        return SettingsService.sharedInstance
    }
    
    //MARK:Lifcycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(settingsViewController.didUpdateConnectionStatus(_:)), name: MultipeerManagerKeys.ConnectionStateChanged, object: nil)
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initializeCells()
    }
    
    
    public func didUpdateConnectionStatus(notification: NSNotification) {
        
        let userInfo = notification.userInfo! as! [String: AnyObject]
        
        dispatch_async(dispatch_get_main_queue()) {
            if let peer = userInfo[MultipeerManagerKeys.PeerId] {
                self.connectionCell.textLabel?.text = "🖥 " + peer.displayName
            }
            else {
                self.connectionCell.textLabel?.text = "No Device Availible"
            }
            
            if let state = userInfo[MultipeerManagerKeys.State] as? String {
                self.connectionCell.detailTextLabel?.text = state
            }
        }
        
    }
    
    //MARK: Initialization
    public func initializeCells() {
        
        let tabBarController = self.tabBarController! as! TabBarController
        
        colorsCell.initialize(settings.colorIndex) { (index) -> Void in
            self.animationSwitchCell.value = false
            tabBarController.stopAnimation()
            self.settings.colorIndex = index
            let color = TabBarItemColor.Colors[index]
            tabBarController.setColor(color)
        }
        
        animationSwitchCell.initialize(settings.enableAnimation) { (enable) -> Void in
            self.settings.enableAnimation = enable
            
            if enable {tabBarController.startAnimation(self.settings.animationDuration)}
            else {tabBarController.stopAnimation()}
        }
        
        animationDurationAdjustmentCell.initialize(settings.animationDuration) { (value) -> Void in
            self.settings.animationDuration = value
            if self.settings.enableAnimation.boolValue { tabBarController.startAnimation(value) }
        }
        
        generalAdjustmentCell.initialize(settings.motionManagerSamplingFrequency) { (value) -> Void in
            self.settings.motionManagerSamplingFrequency = value
        }
        
        
        accelerationAdjustmentCell.initialize(settings.accelerationFilterCutoffFrequency) { (value) -> Void in
            self.settings.accelerationFilterCutoffFrequency = value
        }
        
        accelerationFilterTypeCell.initialize(settings.accelerationFilterType) { (type) -> Void in
            self.settings.accelerationFilterType = type
        }
        
        accelerationAdaptiveSwitchCell.initialize(settings.accelerationAdaptiveFilter) { (isAdaptive) -> Void in
            self.settings.accelerationAdaptiveFilter = isAdaptive
        }
    }

    //MARK:IBActions
    @IBAction func restartButtonDidPressed(sender: AnyObject) {
        settings.clear()
    }
  
    @IBAction func resetButtonDidPressed(sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: " WARNING", message: "Are you sure you want to erase all settings and set back to defaults?", preferredStyle: .Alert)
        
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
        }
        actionSheetController.addAction(noAction)
        
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Destructive) { action -> Void in
            self.settings.reset()
            self.initializeCells()
        }
        actionSheetController.addAction(yesAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}

//MARK: MCBrowserViewControllerDelegate
extension settingsViewController: MCBrowserViewControllerDelegate {
    public func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        
    }
    
    public func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func browserViewController(browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
}
