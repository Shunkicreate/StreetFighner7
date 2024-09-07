import SwiftUI
import CoreMotion

struct PunchTestView: View {
    @StateObject private var motionManager = MotionManager()
    var body: some View {
        HStack {
            VStack(spacing: 20) {
                Button(action: {
                    motionManager.startAccelerometer(interval: 0.1)
                }, label: {
                    Text("加速度センサー開始")
                })
                Button(action: {
                    motionManager.stopAccelerometer()
                }, label: {
                    Text("加速度センサー停止")
                })
                Text("加速度")
                Text("x: \(motionManager.accelerometerData?.acceleration.x ?? 0)")
                Text("y: \(motionManager.accelerometerData?.acceleration.y ?? 0)")
                Text("z: \(motionManager.accelerometerData?.acceleration.z ?? 0)")
                
                Text("猫の手の方向")
                
                if let direction = motionManager.direction {
                    Text(direction.rawValue)
                }
            }
            
            VStack(spacing: 20) {
                Button(action: {
                    motionManager.startDeviceMotion(interval: 0.1)
                }, label: {
                    Text("ポーズセンサー開始")
                })
                Button(action: {
                    motionManager.stopDeviceMotion()
                }, label: {
                    Text("ポーズセンサー停止")
                })
                Text("ポーズ")
                Text("x: \(motionManager.deviceMotionData?.attitude.roll ?? 0)")
                Text("y: \(motionManager.deviceMotionData?.attitude.pitch ?? 0)")
                Text("z: \(motionManager.deviceMotionData?.attitude.yaw ?? 0)")
                
                Text("向き")
                
                if let direction = motionManager.direction {
                    Text(direction.rawValue)
                }
            }
        }
    }
}

//enum CatHandDirection: String {
//    case centr = "真ん中"
//    case left = "左"
//    case right = "右"
//}

extension CatHandDirection {
    static func calcDirection(roll: CGFloat) -> Self {
        if roll > 0.5 {
            return .right
        } else if roll < -0.5 {
            return .left
        } else {
            return .centr
        }
    }
}

// 右: マイナス
// 左: プラス

//final class MotionManager: ObservableObject {
//    /// 加速度センサーデータ
//    @Published var accelerometerData: CMAccelerometerData?
//    /// ジャイロセンサーデータ
//    @Published var gyroData: CMGyroData?
//    /// 前回取得したZを、今回取得したZと比較して、
//    /// 正であれば、上 → 下。
//    /// 負であれば、下 → 上。
//    @Published private var previousZ: CGFloat?
//    @Published var direction: CatHandDirection?
//    
//    private let motionManager = CMMotionManager()
//
//    /// 加速度センサー開始
//    /// - Parameter interval: 取得の間隔
//    func startAccelerometer(interval: CGFloat) {
//        guard motionManager.isAccelerometerAvailable else {
//            fatalError("加速度センサーが搭載されていません")
//        }
//        motionManager.accelerometerUpdateInterval = interval
//        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
//            guard let self, let data else {
//                fatalError("エラー: データがありません")
//            }
//            if error != nil {
//                fatalError("エラー: \(error?.localizedDescription ?? "不明なエラー")")
//            }
//            self.accelerometerData = data
//            
//            print("x: \(self.accelerometerData?.acceleration.x), y: \(self.accelerometerData?.acceleration.y), z: \(self.accelerometerData?.acceleration.z)")
//            
//            // MARK: 猫パンチ判定
//            // 調整可能な閾値。デバイスを振ったと見なす加速度の値。
//            let yThreshold: Double = 1.5
//            let zThreshold: Double = 3.5
//
//            if
//                (fabs(data.acceleration.y) > yThreshold || fabs(data.acceleration.z) > zThreshold),
//                let previousZ = self.previousZ,
//                previousZ > 0 {
//                self.direction = CatHandDirection.calcDirection(roll: data.acceleration.x)
//                print(self.direction?.rawValue)
//            } else {
//                self.direction = nil
//            }
//            self.previousZ = data.acceleration.z
//        }
//    }
//
//    /// 加速度センサー停止
//    func stopAccelerometer() {
//        guard motionManager.isAccelerometerAvailable else {
//            fatalError("加速度センサーが搭載されていません")
//        }
//        motionManager.stopAccelerometerUpdates()
//    }
//    
//    func startGyro(interval: CGFloat) {
//        guard motionManager.isGyroAvailable else {
//            fatalError("ジャイロセンサーが搭載されていません")
//        }
//        motionManager.gyroUpdateInterval = interval
//        motionManager.startGyroUpdates(to: .main) { [weak self] gyroData, gyroError in
//            guard let self, let gyroData else {
//                fatalError("エラー: データがありません")
//            }
//            if gyroError != nil {
//                fatalError("エラー: \(gyroError?.localizedDescription ?? "不明なエラー")")
//            }
//            self.gyroData = gyroData
//            
//            print("x: \(self.gyroData?.rotationRate.x), y: \(self.gyroData?.rotationRate.y), z: \(self.gyroData?.rotationRate.z)")
//        }
//    }
//    
//    func stopGyro() {
//        guard motionManager.isGyroAvailable else {
//            fatalError("加速度センサーが搭載されていません")
//        }
//        motionManager.stopGyroUpdates()
//    }
//}
//
//




