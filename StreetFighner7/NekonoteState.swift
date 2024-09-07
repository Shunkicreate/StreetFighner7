//
//  NekonoteState.swift
//  StreetFighter7
//
//  Created by Kenta Yamada on 2024/09/07.
//

import Foundation
import SwiftUI

// ゲームの状態を表すenum
enum NekonoteState {
    case left
    case center
    case right
    case paused
    case gameOver
}

// ゲームモデルを表すstruct
struct NekonoteModel {
    var state: NekonoteState
    var score: Int
    var playerPosition: CGPoint
    var level: Int
    
    // 初期化メソッド
    init(state: NekonoteState = .center, score: Int = 0, playerPosition: CGPoint = CGPoint(x: 0, y: 0), level: Int = 1) {
        self.state = state
        self.score = score
        self.playerPosition = playerPosition
        self.level = level
    }
}
