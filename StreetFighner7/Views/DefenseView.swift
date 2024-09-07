import SwiftUI
import AVFoundation

struct DefenseView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @State private var gameModel = NekonoteModel(state: .center)
    @State private var churuModel = ChuruModel(position: .center) // ChuruModelを使用
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @StateObject private var motionManager = MotionManager() // MotionManagerを使用
    @StateObject private var resultScore = ResultScore() // ResultScoreを追加
    
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Nekonote状態とChuru状態の表示
                VStack {
                    ZStack {
                        if gameModel.state == .left {
                            Image("nekonote_reverse")
                                .resizable()
                                .scaledToFit()
                                .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.4)
                        } else if gameModel.state == .center {
                            Image("nekonote_reverse")
                                .resizable()
                                .scaledToFit()
                                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.4)
                        } else if gameModel.state == .right {
                            Image("nekonote_reverse")
                                .resizable()
                                .scaledToFit()
                                .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.4)
                        }
                        
                        // アタック時のオーバーレイ
                        if gameModel.isAttacked {
                            ZStack {
                                Image("concentration_line")
                                    .resizable()
                                    .scaledToFill()
                                    .opacity(0.5) // 半透明にして重ね合わせる
                                    .ignoresSafeArea()
                            }
                        }
                    }
                    
                    // Churuの表示
                    ZStack {
                        if churuModel.position == .left {
                            Image("churu_fukuro")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.2)
                        } else if churuModel.position == .center {
                            Image("churu_fukuro")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.2)
                        } else if churuModel.position == .right {
                            Image("churu_fukuro")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.2)
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Button("Left") {
                            gameModel.state = .left
                            handleAttack()
                            
                        }
                        Button("Center") {
                            gameModel.state = .center
                            handleAttack()
                        }
                        Button("Right") {
                            gameModel.state = .right
                            handleAttack()
                        }
                        NavigationLink("Go to Result", destination: ResultView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult, resultScore: resultScore))
                    }.padding()
                    HStack {
                        Button("Left") {
                            churuModel.position = .left
                            handleAvoid()
                        }
                        Button("Center") {
                            churuModel.position = .center
                            handleAvoid()
                        }
                        Button("Right") {
                            churuModel.position = .right
                            handleAvoid()
                        }
                    }
                    // 成功と失敗の合計回数を表示
                    VStack {
                        Text("成功した合計: \(resultScore.totalSuccess)")
                        Text("失敗した合計: \(resultScore.totalFailure)")
                    }.padding()
                    // 結果画面への遷移リンク
                    NavigationLink("Go to Result", destination: ResultView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult, resultScore: resultScore))
                }                .padding()
                .navigationBarBackButtonHidden(true)
            }
            
        }
        .onAppear {
            motionManager.startAccelerometer(interval: 0.1) // 加速度センサー開始
        }
        .onDisappear {
            motionManager.stopAccelerometer() // センサー停止
        }
        .onChange(of: motionManager.accelerometerData) { _ in
            updateGameModelState() // 加速度データが変わるたびに状態を更新
        }
    }
    
    // 加速度データに基づいて NekonoteModel の state と ChuruModel の position を更新
    private func updateGameModelState() {
        guard let y = motionManager.accelerometerData?.acceleration.y else { return }
        
        if y > 0.5 {
            churuModel.updatePosition(x: 1.0) // ChuruModelも更新
        } else if y < -0.5 {
            churuModel.updatePosition(x: -1.0) // ChuruModelも更新
        } else {
            churuModel.updatePosition(x: 0.0) // ChuruModelも更新
        }
    }

    // アタックされたときの処理
    private func handleAttack() {
        if (gameModel.state.toString() == churuModel.position.rawValue){
            actionAttack()
        } else {
            // 当たっていない時
            resultScore.recordFailure(at: churuModel.position)
        }
    }
    
    private func handleAvoid(){
        resultScore.recordAvoid()
    }
    
    private func actionAttack() {
        // サウンドのリストを定義
        let soundNameList = ["attack_1", "attack_2", "attack_3"]
        
        // ランダムなインデックスを生成
        let randomIndex = Int.random(in: 0..<soundNameList.count)
        
        // ランダムに選ばれたサウンド名
        let soundName = soundNameList[randomIndex]
        
        // サウンドを再生
        SoundManager.shared.playSound(soundName)
        
        // バイブレーションも鳴らす
        VibrationManager.shared.triggerNotificationFeedback(type: .success)        
        // アタックされたときの処理
        gameModel.isAttacked = true
        // 回数の保存
        resultScore.recordSuccess(at: churuModel.position)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            gameModel.isAttacked = false
        }
    }
}

#Preview {
    @State var path = NavigationPath()
    @State var isFromResult = false
    return DefenseView(
        rotateScreenModel: .init(),
        path: $path,
        isFromResult: $isFromResult
    )
}
