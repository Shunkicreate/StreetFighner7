import SwiftUI

struct ResultView: View {
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool

    var body: some View {
        VStack {
            Text("Result Screen")
                .font(.largeTitle)
            NavigationLink("Back to Title", destination: TitleView(path: $path, isFromResult: $isFromResult))
                .onTapGesture {
                    isFromResult = true // 遷移元がResultであることを設定
                }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
