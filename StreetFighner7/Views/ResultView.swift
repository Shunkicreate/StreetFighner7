import SwiftUI

struct ResultView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @ObservedObject var resultScore: ResultScore // ResultScoreを追加

    let colorOpacity: Double = 0.6
    // 結果のねこの太り具合を調整
    let neko_fat_standard_score = 10
    let neko_fat_standard_level = 5

    // neko_fat_levelを計算するコンピューテッドプロパティ
    var neko_fat_level: Int {
        let totalSuccess = resultScore.totalSuccess
        return max(1, min(5, Int(totalSuccess / neko_fat_standard_level) / neko_fat_standard_score))
    }
    // neko_fat_imageの名前
    var neko_fat_image: String {
        return "neko_ilust_fat_" + String(neko_fat_level)
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // リザルト画面のコンテンツ
                VStack {
                    Text("リザルト")
                        .font(Font.custom("Mimi_font-Regular", size: 40))
                        .padding()
                    
                    HStack {
                        // 猫画像
                        Image(neko_fat_image).resizable() // Make the image resizable
                            .scaledToFit() // Scale it proportionally
                            .frame(height: geometry.size.height * 0.5)
                            .padding()
                        // 猫の結果
                        VStack(alignment: .leading) {
                            Text("猫")
                                .font(Font.custom("Mimi_font-Regular", size: 35))
                                .padding(.bottom, 5)
                            
                            Text("叩いた回数")
                            Text("\(resultScore.totalSuccess+resultScore.totalFailure)回")
                                .padding(.bottom, 5)
                            
                            Text("取得したチュール")
                            Text("\(resultScore.totalSuccess)個")
                            
                            Text("成功率")
                            let totalAttempts = resultScore.totalSuccess + resultScore.totalFailure
                            let successPercentage = totalAttempts > 0 ? Int(Double(resultScore.totalSuccess) / Double(totalAttempts) * 100) : 0

                            Text("\(successPercentage)%")

                        }
                        .padding()
                        .background(Color.gray.opacity(colorOpacity)) // 背景色
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity) // 横幅を自動調整
                    }
                    
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
