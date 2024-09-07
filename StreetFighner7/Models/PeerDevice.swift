//
//  PeerDevice.swift
//  StreetFighner7
//
//  Created by shunsuke tamura on 2024/09/08.
//

import Foundation
import MultipeerConnectivity

struct PeerDevice: Identifiable, Hashable {
    let id = UUID()
    let peerId: MCPeerID
}
