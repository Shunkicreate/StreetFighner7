import Foundation
import UIKit

class RotateScreenModel: NSObject, ObservableObject {
    /// 指定した方向に画面を回転させる
    func rotateScreen(orientation: UIInterfaceOrientationMask) {
        AppDelegate.orientationLock = orientation
        rotate(screenOrientation: orientation)
    }
    
    private func rotate(screenOrientation :UIInterfaceOrientationMask) {
        // 画面のUIWindowを取得
        guard let window = UIApplication.shared.connectedScenes.compactMap({
            $0 as? UIWindowScene
        }).first?.windows.filter({
            $0.isKeyWindow
        }).first else {
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
}
