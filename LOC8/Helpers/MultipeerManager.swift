//
//  MultipeerClient.swift
//  LOC8
//
//  Created by Marwan Al Masri on 3/27/16.
//  Copyright © 2016 LOC8. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public struct MultipeerManagerKeys {
    
    public static let PeerId: String = "PeerId"
    
    public static let Data: String = "SessionData"
    
    public static let State: String = "SessionState"
}

open class MultipeerManager: NSObject {
    
    /// Get currently used MultipeerManager, singleton pattern
    public static let shared = MultipeerManager()
    
    ///Returns the found peer update notification. Which is use to register with notification center.
    public static let FoundPeerNotification = Notification.Name(rawValue: "FoundPeer")
    
    ///Returns the lost peer update notification. Which is use to register with notification center.
    public static let LostPeerNotification = Notification.Name(rawValue: "LostPeer")
    
    ///Returns the received invitation update notification. Which is use to register with notification center.
    public static let ReceivedInvitationNotification = Notification.Name(rawValue: "ReceivedInvitation")
    
    ///Returns the Connection state did changed notification. Which is use to register with notification center.
    public static let ConnectionStateChangedNotification = Notification.Name(rawValue: "ConnectionStateChanged")
    
    ///Returns the received data update notification. Which is use to register with notification center.
    public static let ReceivedDataNotification = Notification.Name(rawValue: "ReceivedData")
    
    open let ServiceType: String = "LOC8"
    
    var session: MCSession!
    
    open var peer: MCPeerID!
    
    open var browser: MCNearbyServiceBrowser!
    
    open var advertiser: MCNearbyServiceAdvertiser!
    
    open var foundPeers = [MCPeerID]()
    
    open var foundPeersStats = [String: MCSessionState]()
    
    open var invitationHandler: ((Bool, MCSession) -> Void)?
    
    open var isAdvertising: Bool = false  {
        didSet {
            if isAdvertising {
                advertiser.startAdvertisingPeer()
            } else {
                advertiser.stopAdvertisingPeer()
            }
        }
    }
    
    open var isBrowsing: Bool = false {
        didSet {
            if isBrowsing {
                browser.startBrowsingForPeers()
            } else {
                browser.stopBrowsingForPeers()
            }
        }
    }
    
    override init() {
        super.init()
        
        
        #if os(iOS)
            peer = MCPeerID(displayName: UIDevice.current.name)
        #else
            peer = MCPeerID(displayName: Host.current().localizedName!)
        #endif
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: ServiceType)
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: ServiceType)
        advertiser.delegate = self
    }
    
    // MARK: Custom method implementation
    
    open func sendData(dictionaryWithData dictionary: Dictionary<String, String>, toPeer targetPeer: MCPeerID) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let peersArray = [targetPeer]
        
        do {
            try session.send(dataToSend, toPeers: peersArray, with: MCSessionSendDataMode.reliable)
        }
        catch {
            debugPrint(error)
            return false
        }
        
        return true
    }
    
    open func invitePeer(_ peerID: MCPeerID) {
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 30)
    }
    
}

// MARK: MCNearbyServiceBrowserDelegate method implementation
extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        foundPeers.append(peerID)
        
        let userInfo: [AnyHashable: Any] = [MultipeerManagerKeys.PeerId: peerID]
        
        NotificationCenter.default.post(name: MultipeerManager.FoundPeerNotification, object: nil, userInfo: userInfo)
        
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        for (index, aPeer) in foundPeers.enumerated() {
            
            if aPeer == peerID {
                
                foundPeers.remove(at: index)
                foundPeersStats.removeValue(forKey: aPeer.displayName)
                break
            }
        }
        
        let userInfo: [AnyHashable: Any] = [MultipeerManagerKeys.PeerId: peerID]
        
        NotificationCenter.default.post(name: MultipeerManager.LostPeerNotification, object: nil, userInfo: userInfo)
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        debugPrint(error.localizedDescription)
    }
    
}

// MARK: MCNearbyServiceAdvertiserDelegate method implementation
extension MultipeerManager: MCNearbyServiceAdvertiserDelegate {
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.invitationHandler = invitationHandler
        
        let userInfo: [AnyHashable: Any] = [MultipeerManagerKeys.PeerId: peerID]
        
        NotificationCenter.default.post(name: MultipeerManager.ReceivedInvitationNotification, object: nil, userInfo: userInfo)
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        debugPrint(error.localizedDescription)
    }
    
}

// MARK: MCSessionDelegate method implementation
extension MultipeerManager: MCSessionDelegate {
    
    // Remote peer changed state.
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
            
        var userInfo: [AnyHashable: Any] = [MultipeerManagerKeys.State: state.description]
        
        if state != .notConnected {
            userInfo[MultipeerManagerKeys.PeerId] = peerID
        }
        
        self.foundPeersStats[peerID.displayName] = state
        
        NotificationCenter.default.post(name: MultipeerManager.ConnectionStateChangedNotification, object: nil, userInfo: userInfo)
        
        debugPrint("Did change state: \(state.description)")
    }
    
    // Received data from remote peer.
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        let userInfo: [String: AnyObject] =
            [
                MultipeerManagerKeys.Data: data as AnyObject,
                MultipeerManagerKeys.PeerId: peerID
            ]
        
        NotificationCenter.default.post(name: MultipeerManager.ReceivedDataNotification, object: userInfo)
        
        debugPrint("Did receive data: \(data)")
    }
    
    // Received a byte stream from remote peer.
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        
        debugPrint("Did receive stream: \(stream)")
    }
    
    // Start receiving a resource from remote peer.
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        debugPrint("Did start receiving resource named: \(resourceName)")
    }
    
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
        debugPrint("Did finish receiving resource named: \(resourceName)")
    }

    // Made first contact with peer and have identity information about the
    // remote peer (certificate may be nil).
    public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Swift.Void) {
        
    }
    
}

