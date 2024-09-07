import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TitleView() // 最初に表示されるのはタイトル画面
        }
    }
}

#Preview {
    ContentView()
        .previewInterfaceOrientation(.landscapeLeft)  // 横向きに設定
}
