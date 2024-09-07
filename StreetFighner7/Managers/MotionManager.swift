import SwiftUI
import CoreMotion

final class MotionManager: ObservableObject {
    /// 加速度センサーデータ
    @Published var accelerometerData: CMAccelerometerData?
    /// ジャイロセンサーデータ
    @Published var gyroData: CMGyroData?
    /// 前回取得したZを、今回取得したZと比較して、
    /// 正であれば、上 → 下。
    /// 負であれば、下 → 上。
    @Published private var previousZ: CGFloat?
    @Published var direction: CatHandDirection?
    @Published var errorMessage: String?
    
    private let motionManager = CMMotionManager()

    /// 加速度センサー開始
    /// - Parameter interval: 取得の間隔
    func startAccelerometer(interval: CGFloat) {
        // エラーチェック
        guard motionManager.isAccelerometerAvailable else {
            errorMessage = "加速度センサーが利用できません。"
            return
        }
        
        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self, let data else {
                self?.errorMessage = "加速度センサーデータが取得できませんでした。"
                return
            }
            self.accelerometerData = data
        }
    }

    /// 加速度センサー停止
    func stopAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
