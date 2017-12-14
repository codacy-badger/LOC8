//
//  SettingsViewController.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/26/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit
import MultipeerConnectivity

open class settingsViewController: UITableViewController {
    
    //MARK:Properties
    
    @IBOutlet weak var connectionCell: UITableViewCell!
    
    @IBOutlet weak var colorsCell: ColorsTableViewCell!
    
    @IBOutlet weak var animationSwitchCell: SwitchTableViewCell!
    
    @IBOutlet weak var animationDurationAdjustmentCell: AdjustmentTableViewCell!
    
    @IBOutlet weak var generalAdjustmentCell: AdjustmentTableViewCell!
    
    
    @IBOutlet weak var accelerationAdjustmentCell: AdjustmentTableViewCell!
    
    @IBOutlet weak var accelerationFilterTypeCell: FilterTypeTableViewCell!
    
    @IBOutlet weak var accelerationAdaptiveSwitchCell: SwitchTableViewCell!
    
    fileprivate var settings: SettingsService {
        return SettingsService.shared
    }
    
    //MARK:Lifcycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(settingsViewController.didUpdateConnectionStatus(_:)), name: MultipeerManager.ConnectionStateChangedNotification, object: nil)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeCells()
    }
    
    
    @objc open func didUpdateConnectionStatus(_ notification: Notification) {
        
        let userInfo = notification.userInfo! as! [String: AnyObject]
        
        DispatchQueue.main.async {
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
    open func initializeCells() {
        
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
            
            if enable {
                tabBarController.startAnimation(self.settings.animationDuration)
            } else {
                tabBarController.stopAnimation()
            }
        }
        
        animationDurationAdjustmentCell.initialize(settings.animationDuration) { (value) -> Void in
            self.settings.animationDuration = value
            if self.settings.enableAnimation {
                tabBarController.startAnimation(value)
            }
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
    @IBAction func restartButtonDidPressed(_ sender: AnyObject) {
        settings.clear()
    }
  
    @IBAction func resetButtonDidPressed(_ sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: " WARNING", message: "Are you sure you want to erase all settings and set back to defaults?", preferredStyle: .alert)
        
        let noAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(noAction)
        
        let yesAction: UIAlertAction = UIAlertAction(title: "Yes", style: .destructive) { action -> Void in
            self.settings.reset()
            self.initializeCells()
        }
        actionSheetController.addAction(yesAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

//MARK: MCBrowserViewControllerDelegate
extension settingsViewController: MCBrowserViewControllerDelegate {
    public func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    public func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
}
