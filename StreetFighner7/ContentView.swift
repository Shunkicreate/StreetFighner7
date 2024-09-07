import SwiftUI

struct ContentView: View {
    @StateObject var rotateScreenModel = RotateScreenModel()
    @State private var path = NavigationPath() // ナビゲーション履歴を保持
    @State private var isFromResult = false

    var body: some View {
        NavigationStack(path: $path) {
            TitleView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult) // TitleViewにパスを渡す
        }
    }
}

#Preview {
    ContentView()
}
