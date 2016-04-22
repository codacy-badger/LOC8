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
    
    public static let FoundPeer: String = "FoundPeer"
    
    public static let LostPeer: String = "LostPeer"
    
    public static let ReceivedInvitation: String = "ReceivedInvitation"
    
    public static let ConnectionStateChanged: String = "ConnectionStateChanged"
    
    public static let ReceivedData: String = "ReceivedData"
    
    public static let PeerId: String = "PeerId"
    
    public static let Data: String = "SessionData"
    
    public static let State: String = "SessionState"
}

public class MultipeerManager: NSObject {
    
    public let ServiceType: String = "LOC8"
    
    var session: MCSession!
    
    public var peer: MCPeerID!
    
    public var browser: MCNearbyServiceBrowser!
    
    public var advertiser: MCNearbyServiceAdvertiser!
    
    public var foundPeers = [MCPeerID]()
    
    public var foundPeersStats = [String: MCSessionState]()
    
    public var invitationHandler: ((Bool, MCSession) -> Void)?
    
    public var isAdvertising: Bool = false  {
        didSet {
            if isAdvertising {
                advertiser.startAdvertisingPeer()
            }
            else {
                advertiser.stopAdvertisingPeer()
            }
        }
    }
    
    public var isBrowsing: Bool = false {
        didSet {
            if isBrowsing {
                browser.startBrowsingForPeers()
            }
            else {
                browser.stopBrowsingForPeers()
            }
        }
    }
    
    
    /**
     * Get currently used MultipeerManager, singleton pattern
     *
     * - Returns: `MultipeerManager`
     */
    public class var sharedInstance: MultipeerManager {
        struct Singleton {
            static let instance = MultipeerManager()
        }
        
        return Singleton.instance
    }
    
    override init() {
        super.init()
        
        
        #if os(iOS)
            peer = MCPeerID(displayName: UIDevice.currentDevice().name)
        #else
            peer = MCPeerID(displayName: NSHost.currentHost().localizedName!)
        #endif
        
        session = MCSession(peer: peer)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: ServiceType)
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: ServiceType)
        advertiser.delegate = self
    }
    
    // MARK: Custom method implementation
    
    public func sendData(dictionaryWithData dictionary: Dictionary<String, String>, toPeer targetPeer: MCPeerID) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedDataWithRootObject(dictionary)
        let peersArray = [targetPeer]
        
        do {
            try session.sendData(dataToSend, toPeers: peersArray, withMode: MCSessionSendDataMode.Reliable)
        }
        catch {
            debugPrint(error)
            return false
        }
        
        return true
    }
    
    public func invitePeer(peerID: MCPeerID) {
        browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 30)
    }
    
}

// MARK: MCNearbyServiceBrowserDelegate method implementation
extension MultipeerManager: MCNearbyServiceBrowserDelegate {
    
    public func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        foundPeers.append(peerID)
        
        let userInfo: [NSObject: AnyObject] = [MultipeerManagerKeys.PeerId: peerID]
        
        NSNotificationCenter.defaultCenter().postNotificationName(MultipeerManagerKeys.FoundPeer, object: nil, userInfo: userInfo)
        
    }
    
    public func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        for (index, aPeer) in foundPeers.enumerate(){
            
            if aPeer == peerID {
                
                foundPeers.removeAtIndex(index)
                foundPeersStats.removeValueForKey(aPeer.displayName)
                break
            }
        }
        
        let userInfo: [NSObject: AnyObject] = [MultipeerManagerKeys.PeerId: peerID]
        
        NSNotificationCenter.defaultCenter().postNotificationName(MultipeerManagerKeys.LostPeer, object: nil, userInfo: userInfo)
    }
    
    public func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        debugPrint(error.localizedDescription)
    }
    
}

// MARK: MCNearbyServiceAdvertiserDelegate method implementation
extension MultipeerManager: MCNearbyServiceAdvertiserDelegate {
    
    public func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: ((Bool, MCSession) -> Void)) {
        self.invitationHandler = invitationHandler
        
        let userInfo: [NSObject: AnyObject] = [MultipeerManagerKeys.PeerId: peerID]
        
        NSNotificationCenter.defaultCenter().postNotificationName(MultipeerManagerKeys.ReceivedInvitation, object: nil, userInfo: userInfo)
    }
    
    public func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        debugPrint(error.localizedDescription)
    }
    
}

// MARK: MCSessionDelegate method implementation
extension MultipeerManager: MCSessionDelegate {
    
    public func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
            
        var userInfo: [NSObject: AnyObject] = [MultipeerManagerKeys.State: state.description]
        
        if state != .NotConnected {
            userInfo[MultipeerManagerKeys.PeerId] = peerID
        }
        
        self.foundPeersStats[peerID.displayName] = state
        
        NSNotificationCenter.defaultCenter().postNotificationName(MultipeerManagerKeys.ConnectionStateChanged, object: nil, userInfo: userInfo)
        
        debugPrint("Did change state: \(state.description)")
    }
    
    public func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        let userInfo: [String: AnyObject] =
            [
                MultipeerManagerKeys.Data: data,
                MultipeerManagerKeys.PeerId: peerID
            ]
        
        NSNotificationCenter.defaultCenter().postNotificationName(MultipeerManagerKeys.ReceivedData, object: userInfo)
        
        debugPrint("Did receive data: \(data)")
    }
    
    public func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
        debugPrint("Did receive stream: \(stream)")
    }
    
    public func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
        debugPrint("Did start receiving resource named: \(resourceName)")
    }
    
    public func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
        debugPrint("Did finish receiving resource named: \(resourceName)")
    }
    
}

