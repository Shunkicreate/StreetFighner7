import UIKit

class VibrationManager {
    
    // シングルトンパターンでインスタンスを共有
    static let shared = VibrationManager()
    
    private init() {}  // プライベートイニシャライザで外部からのインスタンス生成を防ぐ
    
    // UIImpactFeedbackGeneratorを使った触覚フィードバック
    func triggerImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare() // フィードバックが呼ばれる前に準備
        generator.impactOccurred()
    }
    
    // UINotificationFeedbackGeneratorを使った通知フィードバック
    func triggerNotificationFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare() // フィードバックが呼ばれる前に準備
        generator.notificationOccurred(type)
    }
}
