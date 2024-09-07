import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.landscape // 横向きに固定

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
