import SwiftUI

struct ResultView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @ObservedObject var resultScore: ResultScore // ResultScoreを追加

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
                    .font(Font.custom("Mimi_font-Regular", size: 40))
                    .padding()

                HStack {
                    // 猫の結果
                    VStack(alignment: .leading) {
                        Text("猫")
                            .font(Font.custom("Mimi_font-Regular", size: 35))
                            .padding(.bottom, 5)

                        Text("叩いた回数")
                        Text("\(resultScore.totalSuccess)回")
                            .padding(.bottom, 5)

                        Text("取得したチュール")
                        Text("\(resultScore.totalSuccess)個")
                    }
                    .padding()
                    .background(Color.gray.opacity(colorOpacity)) // 背景色
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity) // 横幅を自動調整

                    // 飼い主の結果
                    VStack(alignment: .leading) {
                        Text("かいぬし")
                            .font(Font.custom("Mimi_font-Regular", size: 35))
                            .padding(.bottom, 5)

                        Text("避けた回数")
                        Text("\(resultScore.totalAvoid)回")
                            .padding(.bottom, 5)

                        Text("あげてしまったチュール")
                        Text("\(resultScore.totalFailure)個")
                    }
                    .padding()
                    .background(Color.gray.opacity(colorOpacity)) // 背景色
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity) // 横幅を自動調整
                }
                .padding()

                Spacer()

                // タイトル画面に戻るボタン
                NavigationLink("トップへ戻る", destination: TitleView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult))
                    .onTapGesture {
                        isFromResult = true // 遷移元がResultであることを設定
                        resultScore.resetScores() // スコアをリセット
                    }
                    .padding()
                    .background(Color.gray.opacity(colorOpacity))
                    .foregroundColor(.black)
                    .cornerRadius(10)
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
        .navigationBarBackButtonHidden(true)
        .padding()
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

struct StateWrapperForPreview: View {
    @State private var path = NavigationPath()
    @State private var isFromResult = false
    @StateObject private var resultScore = ResultScore() // ResultScoreを追加

    var body: some View {
        ResultView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult, resultScore: resultScore)
    }
}

#Preview{
    StateWrapperForPreview()
}
