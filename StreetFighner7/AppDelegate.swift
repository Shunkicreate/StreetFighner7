import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    // 横向きに固定
    static var orientationLock = UIInterfaceOrientationMask.landscapeLeft

    /// 画面の向きを設定
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
