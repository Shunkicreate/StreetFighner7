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
    var isAttacked: Bool // スペルミスを修正
    
    // 初期化メソッド
    init(state: NekonoteState = .center, score: Int = 0, playerPosition: CGPoint = CGPoint(x: 0, y: 0), level: Int = 1, isAttacked: Bool = false) {
        self.state = state
        self.score = score
        self.playerPosition = playerPosition
        self.level = level
        self.isAttacked = isAttacked
    }
}

enum CatHandDirection: String {
    case centr = "真ん中"
    case left = "左"
    case right = "右"
}

extension CatHandDirection {
    static func calcDirection(x: CGFloat) -> Self {
        if x > 0.5 {
            return .right
        } else if x < -0.5 {
            return .left
        } else {
            return .centr
        }
    }
}
