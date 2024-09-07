//
//  ParticipantsViewModel.swift
//  StreetFighner7
//
//  Created by Taishin Miyamoto on 2024/09/08.
//

import Foundation
import MultipeerConnectivity
import SwiftUI
import Combine

class JoinRoomViewModel: NSObject, ObservableObject {
    private let advertiser: MCNearbyServiceAdvertiser
    private let session: MCSession
    private let serviceType = "nearby-devices"
    
    @Published var isAdvertised: Bool = false {
        didSet {
            isAdvertised ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    @Published var permissionRequest: PermissionRequest?
    
    @Published var joinedPeer: [PeerDevice] = []
    
    @Published var messages: [Message] = []
    let messageReceiver = PassthroughSubject<Message, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    override init() {
        let peer = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peer)
        
        advertiser = MCNearbyServiceAdvertiser(
            peer: peer,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        
        super.init()
        
        advertiser.delegate = self
        session.delegate = self
        
        messageReceiver
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.messages.append($0)
            }
            .store(in: &subscriptions)
        
        advertiser.startAdvertisingPeer()
    }
    
    func join(peer: PeerDevice) {
        joinedPeer.append(peer)
    }
    
    private func receiveMessage(message: Message) {
        messages.append(message)
    }
    
    func send(message: Message) {
        guard let data = message.toJson()?.data(using: .utf8) else {
            return
        }
        
        // 相手に送信
        try? session.send(data, toPeers: [joinedPeer.last!.peerId], with: .reliable)
        
        // 自分にも送信
        messageReceiver.send(message)
    }
}

extension JoinRoomViewModel: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //
    }
}



extension JoinRoomViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        permissionRequest = PermissionRequest(
            peerId: peerID,
            onRequest: {
                [weak self] permission in
                invitationHandler(permission, permission ? self?.session : nil)
            }
        )
    }
}

extension JoinRoomViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        //
    }
    
    // sessionを通して送られてくるmessageをViewLogicのmessageReciverに流す
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let last = joinedPeer.last, last.peerId == peerID, let message = String(data: data, encoding: .utf8) else {
            return
        }
        
        guard let _message = Message.fromJson(jsonString: message) else {
            return
        }
        
        messageReceiver.send(_message)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //
    }
}
