import Foundation
import UIKit

class ContentViewModel: NSObject, ObservableObject {
    @Published var screenOrientation: String
    
    override init() {
        screenOrientation = ""
    }
    
    // 時計回りに画面を回転させる
    func rotateClockWiseScreen() {
        switch AppDelegate.orientationLock {
        case .portrait:
            rotate(screenOrientation: .landscapeLeft)
            print("時計回り portrait → landscapeLeft")
        case .landscapeRight:
            rotate(screenOrientation: .portrait)
            print("時計回り landscapeRight → portrait")
        case .landscapeLeft:
            print("時計回りに回れないよ")
        case .all:
            // 画面の向きが固定されていない時の処理
            switch UIDevice.current.orientation {
            case .portrait:
                rotate(screenOrientation: .landscapeLeft)
                print("解除中 時計回り portrait → landscapeLeft")
            case .landscapeLeft:
                print("解除中 時計回りに回れないよ")
            case .landscapeRight:
                rotate(screenOrientation: .portrait)
                print("解除中 時計回り landscapeRight → portrait")
            default:
                print("UIDevice.current.orientation Unknown")
            }
        default:
            print("AppDelegate.orientationLock Unknown")
        }
    }
    
    // 反時計回りに画面を回転させる
    func rotateCounterClockWiseScreen() {
        switch AppDelegate.orientationLock {
        case .portrait:
            rotate(screenOrientation: .landscapeRight)
            print("反時計回り portrait → landscapeRight")
        case .landscapeLeft:
            rotate(screenOrientation: .portrait)
            print("反時計回り landscapeLeft → portrait")
        case .landscapeRight:
            print("反時計回りに回れないよ")
        case .all:
            // 画面の向きが固定されていない時の処理
            switch UIDevice.current.orientation {
            case .portrait:
                rotate(screenOrientation: .landscapeRight)
                print("解除中 反時計回り portrait → landscapeRight")
            case .landscapeLeft:
                rotate(screenOrientation: .portrait)
                print("解除中 反時計回り landscapeLeft → portrait")
            case .landscapeRight:
                print("解除中 反時計回りに回れないよ")
            default:
                print("UIDevice.current.orientation Unknown")
            }
        default:
            print("AppDelegate.orientationLock Unknown")
        }
    }
    
    func unRockScreenOrientation() {
        // 一旦現在の画面の向きに直す
        switch UIDevice.current.orientation {
        case .portrait:
            self.rotate(screenOrientation: .portrait)
            print("解除 portrait")
        case .landscapeLeft:
            // UIDeviceOrientationとUIInterfaceOrientationMaskとでは向きが逆？
            self.rotate(screenOrientation: .landscapeRight)
            print("解除 landscapeLeft")
        case .landscapeRight:
            // UIDeviceOrientationとUIInterfaceOrientationMaskとでは向きが逆？
            self.rotate(screenOrientation: .landscapeLeft)
            print("解除 landscapeRight")
        default:
            self.rotate(screenOrientation: .portrait)
            print("解除 不明 → portrait")
        }
        
        // 画面向きを固定している状態を解除する
        self.rotate(screenOrientation: .all)
        
        self.screenOrientation = ""
    }
    
    // 画面を回転させる処理
    private func rotate(screenOrientation :UIInterfaceOrientationMask) {
        // 現在の画面の状態を表示するための文章を更新
        self.getNowScreenOrientationString(screenOrientation: screenOrientation)
        
        AppDelegate.orientationLock = screenOrientation
        if #available(iOS 16.0, *) {
            ios16Rotate(screenOrientation: screenOrientation)
        } else {
            UIDevice.current.setValue(screenOrientation.rawValue, forKey: "orientation")
        }
    }
    
    // iOS16以降の場合の画面の回転処理を実行
    private func ios16Rotate(screenOrientation :UIInterfaceOrientationMask) {
        // 画面のUIWindowを取得
        guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.windows.filter({ $0.isKeyWindow }).first else {
            return
        }
        
        // SupportedInterfaceOrientationsを更新する
        window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        
        if screenOrientation == .all {
            return
        }
        
        guard let windowScene = window.windowScene else {
            return
        }
        // 画面の向きの状態を更新して、向きを固定する
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: screenOrientation)) { error in
            print(error)
        }
    }
    
    // 現在の画面の状態を表示するための文章を更新
    private func getNowScreenOrientationString(screenOrientation :UIInterfaceOrientationMask) {
        switch screenOrientation {
        case .portrait:
            self.screenOrientation = "縦向き"
        case .landscapeLeft:
            self.screenOrientation = "横向き（カメラの位置が右にある）"
        case .landscapeRight:
            self.screenOrientation = "横向き（カメラの位置が左にある）"
        default:
            self.screenOrientation = ""
        }
    }
}
