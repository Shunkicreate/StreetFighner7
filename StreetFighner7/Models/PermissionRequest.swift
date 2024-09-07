//
//  PermissionRequest.swift
//  StreetFighner7
//
//  Created by shunsuke tamura on 2024/09/08.
//

import MultipeerConnectivity

struct PermissionRequest: Identifiable {
    let id = UUID()
    let peerId: MCPeerID
    let onRequest: (Bool) -> Void
}
