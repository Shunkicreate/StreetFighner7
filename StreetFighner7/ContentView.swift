import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath() // ナビゲーション履歴を保持
    @State private var isFromResult = false

    var body: some View {
        NavigationStack(path: $path) {
            TitleView(path: $path, isFromResult: $isFromResult) // TitleViewにパスを渡す
        }
    }
}

#Preview {
    ContentView()
}
