import Foundation
import SwiftUI

// ゲームの状態を表すenum
enum NekonoteState {
    case left
    case center
    case right
    case paused
    case gameOver
    func toString() -> String {
            switch self {
            case .left:
                return "left"
            case .center:
                return "center"
            case .right:
                return "right"
            case .paused:
                return "paused"
            case .gameOver:
                return "gameOver"
            }
        }
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

// Churuのモデルを表すstruct
struct ChuruModel {
    var position: CatHandDirection
    
    // 初期化メソッド
    init(position: CatHandDirection = .center) {
        self.position = position
    }
    
    // Churuの位置を更新するメソッド
    mutating func updatePosition(x: CGFloat) {
        self.position = CatHandDirection.calcDirection(x: x)
    }
}

struct CatHandModel {
    var isAttacking: Bool
    var isAttack: Bool
    var previousZ: CGFloat
    var direction: CatHandDirection
    
    init(position: CatHandDirection = .center) {
        self.isAttacking = false
        self.isAttack = false
        self.previousZ = 0
        self.direction = position
    }
    
    mutating func updateIsAttacking(isAttacking: Bool) {
        self.isAttacking = isAttacking
    }

    mutating func updateIsAttack(isAttack: Bool) {
        self.isAttack = isAttack
    }
    
    mutating func updatePreviousZ(previousZ: CGFloat) {
        self.previousZ = previousZ
    }
    
    mutating func updateDirection(direction: CatHandDirection) {
        self.direction = direction
    }
}

enum CatHandDirection: String {
    case center
    case left
    case right
}

extension CatHandDirection {
    static func calcDirection(x: CGFloat) -> Self {
        if x > 0.5 {
            return .right
        } else if x < -0.5 {
            return .left
        } else {
            return .center
        }
    }
}
