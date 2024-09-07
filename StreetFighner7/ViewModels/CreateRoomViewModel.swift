//
//  CreateRoomViewModel.swift
//  StreetFighner7
//
//  Created by shunsuke tamura on 2024/09/08.
//

import Foundation
import MultipeerConnectivity
import SwiftUI
import Combine

class CreateRoomViewModel: NSObject, ObservableObject {
    @Published var sessionState: MCSessionState = .notConnected
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    private let session: MCSession
    private let serviceType = "nearby-devices"
    
    @Published var peers: [PeerDevice] = []
    @Published var selectedPeer: PeerDevice? {
        didSet {
            print("Selected peer: \(selectedPeer?.peerId.displayName ?? "nil")")
        }
    }
    var joinedPeer: [PeerDevice] = []
    
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
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        
        super.init()
        
        browser.delegate = self
        advertiser.delegate = self
        session.delegate = self
        
        messageReceiver
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.receiveMessage(message: $0)
            }
            .store(in: &subscriptions)
        
        browser.startBrowsingForPeers()
    }
    
    func finishBrowsing() {
        browser.stopBrowsingForPeers()
    }
    
    // ① 部屋を用意して，相手を招待する
    func invite(_selectedPeer: PeerDevice) {
        selectedPeer = _selectedPeer
        browser.invitePeer(_selectedPeer.peerId, to: session, withContext: nil, timeout: 60)
    }
    
    // ② 招待した相手が入っていたら，この関数を使って自分も部屋に入ったことにする
    func join() {
        if !isParticipantsJoined() {
            return
        }
        
        joinedPeer.append(selectedPeer!)
    }
    
    func isParticipantsJoined() -> Bool {
        guard let selectedPeer = selectedPeer else {
            return false
        }
        if !session.connectedPeers.contains(selectedPeer.peerId) {
            return false
        }
        
        return true
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

extension CreateRoomViewModel: MCNearbyServiceBrowserDelegate {
    // 接続可能なデバイスをappendする
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Add peer '\(peerID.displayName)")
        peers.append(PeerDevice(peerId: peerID))
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        peers.removeAll(where: { $0.peerId == peerID })
    }
}



extension CreateRoomViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        //
    }
}

extension CreateRoomViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        self.sessionState = state
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
