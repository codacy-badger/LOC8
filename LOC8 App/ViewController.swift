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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public override func viewWillAppear() {
        super.viewWillAppear()
        preferredContentSize = view.fittingSize
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didUpdatePeer(_:)), name: MultipeerManager.FoundPeerNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didUpdatePeer(_:)), name: MultipeerManager.LostPeerNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didUpdatePeer(_:)), name: MultipeerManager.ConnectionStateChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceivedData(_:)), name: MultipeerManager.ReceivedDataNotification, object: nil)
    }
    
    public override func viewDidDisappear() {
        super.viewDidDisappear()
        NotificationCenter.default.removeObserver(self, name: MultipeerManager.FoundPeerNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: MultipeerManager.LostPeerNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: MultipeerManager.ConnectionStateChangedNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: MultipeerManager.ReceivedDataNotification, object: nil)
    }
    
    public override var representedObject: Any? {
        didSet {
        }
    }
    
    @objc public func didUpdatePeer(_ notification: NSNotification) {
        tableView.reloadData()
    }
    
    @objc public func didReceivedData(_ notification: NSNotification) {
        
        let object = notification.object! as! [String: AnyObject]
        
        let peer = object[MultipeerManagerKeys.PeerId] as! MCPeerID
        
        let data = object[MultipeerManagerKeys.Data] as! NSData
        
        let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [String: String]
        
        let content = dataDictionary["message"]
        
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = "Did Received Data"
        myPopup.informativeText = "Did received data from \(peer.displayName)\nContent:\n\t\(String(describing: content))"
        myPopup.alertStyle = NSAlert.Style.warning
        myPopup.addButton(withTitle: "OK")
        myPopup.runModal()
        
    }


}

extension ViewController : NSTableViewDataSource {
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return MultipeerManager.shared.foundPeers.count
    }
}

extension ViewController : NSTableViewDelegate {
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let peer = MultipeerManager.shared.foundPeers[row]
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PeerCell"), owner: nil) as? PeerCell {
            cell.textField?.stringValue = "📱" + peer.displayName
            cell.peer = peer
            
            if let state = MultipeerManager.shared.foundPeersStats[peer.displayName] {
                switch state {
                case .notConnected:
                    cell.connectButton.title = "Connect"
                    cell.connectButton.isEnabled = true
                case .connecting:
                    cell.connectButton.title = "Connecting"
                    cell.connectButton.isEnabled = false
                case .connected:
                    cell.connectButton.title = "Connected"
                    cell.connectButton.isEnabled = false
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
    
    @IBAction func ConnectionDidPressed(_ sender: NSButtonCell) {
        if let peer = self.peer {
            MultipeerManager.shared.invitePeer(peer)
        }
    }
}



