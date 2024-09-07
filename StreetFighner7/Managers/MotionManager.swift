import SwiftUI
import CoreMotion

final class MotionManager: ObservableObject {
    /// 加速度センサーデータ
    @Published var accelerometerData: CMAccelerometerData?
    /// Deviceポーズデータ
    @Published var deviceMotionData: CMDeviceMotion?
    /// ジャイロセンサーデータ
    @Published var gyroData: CMGyroData?
    
    /// 前回取得したZを、今回取得したZと比較して、
    /// 正であれば、上 → 下。
    /// 負であれば、下 → 上。
    @Published private var previousZ: CGFloat?
    @Published var isAttack: Bool? //攻撃したかどうかか
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
            
            print("x: \(self.accelerometerData?.acceleration.x), y: \(self.accelerometerData?.acceleration.y), z: \(self.accelerometerData?.acceleration.z)")
            
            // MARK: 猫パンチ判定
            // 調整可能な閾値。デバイスを振ったと見なす加速度の値。
            let yThreshold: Double = 1.5
            let zThreshold: Double = 3.5

            if 
                (fabs(data.acceleration.y) > yThreshold || fabs(data.acceleration.z) > zThreshold),
                let previousZ = self.previousZ,
                previousZ > 0 {
                self.isAttack = true
//                self.direction = CatHandDirection.calcDirection(roll: data.acceleration.x)
//                print(self.direction?.rawValue)
            } else {
                self.isAttack = false
                self.direction = nil
            }
            self.previousZ = data.acceleration.z
        }
    }

    /// 加速度センサー停止
    func stopAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.stopAccelerometerUpdates()
        }
    }

    func startDeviceMotion(interval: CGFloat) {
        guard motionManager.isDeviceMotionAvailable else {
                    errorMessage = "ポーズセンサーが利用できません。"
                    return
                }
                
                motionManager.deviceMotionUpdateInterval = interval
                motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
                    guard let self, let data else {
                        self?.errorMessage = "ポーズセンサーデータが取得できませんでした。"
                        return
                    }
                    self.deviceMotionData = data
                }
    }

    func stopDeviceMotion() {
        guard motionManager.isDeviceMotionAvailable else {
            fatalError("ポーズセンサーが搭載されていません")
        }
        motionManager.stopDeviceMotionUpdates()
    }
}
