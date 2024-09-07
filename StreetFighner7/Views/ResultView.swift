import SwiftUI

struct ResultView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool

    // モックデータ
    let catResult = ("猫", "叩いた回数", "30回", "取得したチュール", "15個")
    let ownerResult = ("飼い主", "避けた回数", "15回", "あげてしまったチュール", "15個")
    
    let colorOpacity: Double = 0.6

    var body: some View {
        ZStack {
            // 背景画像を追加
            Image("background") // 背景画像名を指定
                .resizable() // 画像をリサイズ可能に
                .scaledToFill() // 画像をフレーム全体にフィット
                .ignoresSafeArea() // セーフエリアを無視して全画面に表示

            // リザルト画面のコンテンツ
            VStack {
                Text("リザルト")
                    .font(.largeTitle)
                    .padding()

                HStack {
                    // 猫の結果
                    VStack(alignment: .leading) {
                        Text(catResult.0)
                            .font(.title)
                            .padding(.bottom, 5)

                        Text(catResult.1)
                        Text(catResult.2)
                            .padding(.bottom, 5)

                        Text(catResult.3)
                        Text(catResult.4)
                    }
                    .padding()
                    .background(Color.gray.opacity(colorOpacity)) // 背景色
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity) // 横幅を自動調整

                    // 飼い主の結果
                    VStack(alignment: .leading) {
                        Text(ownerResult.0)
                            .font(.title)
                            .padding(.bottom, 5)

                        Text(ownerResult.1)
                        Text(ownerResult.2)
                            .padding(.bottom, 5)

                        Text(ownerResult.3)
                        Text(ownerResult.4)
                    }
                    .padding()
                    .background(Color.gray.opacity(colorOpacity)) // 背景色
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity) // 横幅を自動調整
                }
                .padding()

                Spacer()

                // タイトル画面に戻るボタン
                NavigationLink("Back to Title", destination: TitleView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult))
                    .onTapGesture {
                        isFromResult = true // 遷移元がResultであることを設定
                    }
                    .padding()
                    .background(Color.gray.opacity(colorOpacity))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct StateWrapperForPreview: View {
    @State private var path = NavigationPath()
    @State private var isFromResult = false

    var body: some View {
        ResultView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult)
    }
}

#Preview{
    StateWrapperForPreview()
}
