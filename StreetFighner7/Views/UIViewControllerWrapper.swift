import SwiftUI

struct PortraitViewControllerWrapper<Content: View>: UIViewControllerRepresentable {
    let content: Content
    
    func makeUIViewController(context: Context) -> UIViewController {
        return PortraitHostingController(rootView: content)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // 更新処理（特に何もする必要はありません）
    }
}
