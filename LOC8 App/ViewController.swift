//
//  ViewController.swift
//  LOC8 App
//
//  Created by Marwan Al Masri on 3/26/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

public class ViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setDelegate(self)
        tableView.setDataSource(self)
    }
    
    public override func viewWillAppear() {
        super.viewWillAppear()
        preferredContentSize = view.fittingSize
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didUpdatePeer(_:)), name: MultipeerManagerKeys.FoundPeer, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didUpdatePeer(_:)), name: MultipeerManagerKeys.LostPeer, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didUpdatePeer(_:)), name: MultipeerManagerKeys.ConnectionStateChanged, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didReceivedData(_:)), name: MultipeerManagerKeys.ReceivedData, object: nil)
    }
    
    public override func viewDidDisappear() {
        super.viewDidDisappear()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MultipeerManagerKeys.FoundPeer, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MultipeerManagerKeys.LostPeer, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MultipeerManagerKeys.ConnectionStateChanged, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MultipeerManagerKeys.ReceivedData, object: nil)
    }
    
    public override var representedObject: AnyObject? {
        didSet {
        }
    }
    
    public func didUpdatePeer(notification: NSNotification) {
        tableView.reloadData()
    }
    
    public func didReceivedData(notification: NSNotification) {
        
        let object = notification.object! as! [String: AnyObject]
        
        let peer = object[MultipeerManagerKeys.PeerId] as! MCPeerID
        
        let data = object[MultipeerManagerKeys.Data] as! NSData
        
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [String: String]
        
        let content = dataDictionary["message"]
        
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = "Did Received Data"
        myPopup.informativeText = "Did received data from \(peer.displayName)\nContent:\n\t\(content)"
        myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
        myPopup.addButtonWithTitle("OK")
        myPopup.runModal()
        
    }


}

extension ViewController : NSTableViewDataSource {
    
    public func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return MultipeerManager.sharedInstance.foundPeers.count
    }
}

extension ViewController : NSTableViewDelegate {
    public func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let peer = MultipeerManager.sharedInstance.foundPeers[row]
        
        if let cell = tableView.makeViewWithIdentifier("PeerCell", owner: nil) as? PeerCell {
            cell.textField?.stringValue = "📱" + peer.displayName
            cell.peer = peer
            
            if let state = MultipeerManager.sharedInstance.foundPeersStats[peer.displayName] {
                switch state {
                case .NotConnected:
                    cell.connectButton.title = "Connect"
                    cell.connectButton.enabled = true
                case .Connecting:
                    cell.connectButton.title = "Connecting"
                    cell.connectButton.enabled = false
                case .Connected:
                    cell.connectButton.title = "Connected"
                    cell.connectButton.enabled = false
                }
                
            }
            
            return cell
        }
        return nil
    }
    
}


public class PeerCell: NSTableCellView {
    
    @IBOutlet weak var connectButton: NSButton!
    
    public var peer: MCPeerID?
    
    @IBAction func connectButtonDidPressed(sender: NSButton){
        if let peer = self.peer {
            MultipeerManager.sharedInstance.invitePeer(peer)
        }
    }
}



