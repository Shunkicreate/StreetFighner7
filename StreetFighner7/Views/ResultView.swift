import SwiftUI

// 太り具合に応じた文言のenum
enum NekoStatus: String {
    case daifugo = "だいふごう"
    case fugoNeko = "ふごうねこ"
    case normalNeko = "ふつうのねこ"
    case moreTuna = "ツナ缶もっとくれ"
    case helpMe = "助けてにゃ"
    
    static func status(for fatLevel: Int) -> NekoStatus {
        switch fatLevel {
        case 5:
            return .daifugo
        case 4:
            return .fugoNeko
        case 3:
            return .normalNeko
        case 2:
            return .moreTuna
        default:
            return .helpMe
        }
    }
}

struct ResultView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @ObservedObject var resultScore: ResultScore // ResultScoreを追加

    let colorOpacity: Double = 1.0
    // 結果のねこの太り具合を調整
    let neko_fat_standard_score = 10
    let neko_fat_standard_level = 5
    
    var body: some View {
        // 太り具合の計算
        let nonlimit_neko_fat_level = Int(ceil(Double(resultScore.totalSuccess) / (Double(neko_fat_standard_score) / Double(neko_fat_standard_level))))
        let neko_fat_level = max(1, min(nonlimit_neko_fat_level, Int(neko_fat_standard_level)))
        
        let neko_fat_image = "neko_ilust_fat_" + String(neko_fat_level)
        let neko_status = NekoStatus.status(for: neko_fat_level).rawValue
        
        GeometryReader { geometry in
                    VStack {
                Text("けっか: \(neko_status)")
                    .font(Font.custom("Mimi_font-Regular", size: 40))
                    .padding()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .trailing) {
                        // 猫画像
                        Image(neko_fat_image).resizable() // Make the image resizable
                            .scaledToFit() // Scale it proportionally
                            .frame(height: geometry.size.height * 0.5)
                        
                        // タイトル画面に戻るボタン
                        NavigationLink("トップへもどる", destination: TitleView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult))
                            .onTapGesture {
                                isFromResult = true // 遷移元がResultであることを設定
                                resultScore.resetScores() // スコアをリセット
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                            .font(Font.custom("Mimi_font-Regular", size: 20))
                    }

                    // 猫の結果
                    VStack(alignment: .leading) {
                        Text("猫")
                            .padding(.bottom, 5)
                        
                        Text("叩いた回数")
                        Text("\(resultScore.totalSuccess+resultScore.totalFailure)回")
                            .padding(.bottom, 5)
                        
                        Text("取得したツナかん")
                        Text("\(resultScore.totalSuccess)個")
                        
                        Text("成功率")
                        let totalAttempts = resultScore.totalSuccess + resultScore.totalFailure
                        let successPercentage = totalAttempts > 0 ? Int(Double(resultScore.totalSuccess) / Double(totalAttempts) * 100) : 0

                        Text("\(successPercentage)%")

                    }
                    .font(Font.custom("Mimi_font-Regular", size: 25))
                    .padding()
                    .frame(width: 500, alignment: .leading)
                    .background(Color.gray.opacity(0.8))
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                }
                .offset(y: -10)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .padding()
            .background {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }.onAppear {
                // 画面ロード時にサウンドを再生する
                SoundManager.shared.playSound("result_sound")
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
