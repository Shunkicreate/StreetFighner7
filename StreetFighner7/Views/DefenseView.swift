import SwiftUI
import AVFoundation

struct DefenseView: View {
    @StateObject private var motionManager = MotionManager()
    @StateObject private var resultScore = ResultScore()
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @StateObject private var gameCountdownModel = GameCountdownModel()
    @State private var gameModel = NekonoteModel(state: .center)
    @State private var churuModel = ChuruModel(position: .center)
    @State private var audioPlayer: AVAudioPlayer?
    @State private var countdown: Int = 15
    @State private var showResultButton = false
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Image(.churuFukuro)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)

                Image(.nekonoteReverse)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(gameModel.isAttacked ? 1.05 : 0.4, anchor: .top)
                    .offset(
                        x: {
                            switch gameModel.state {
                            case .left:
                                geometry.size.width / -3
                            case .center:
                                0
                            case .right:
                                geometry.size.width / 3
                            case .paused, .gameOver:
                                0
                            }
                        }(),
                        y: gameModel.isAttacked ? 0 : -geometry.size.height * 1.05
                    )
            }
            .navigationBarBackButtonHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom, content: {
                // TODO: 削除(デバッグ用)
                #if DEBUG
                HStack {
                    Button("Left") {
                        handleAttack()
                        gameModel.state = .left
                    }.foregroundStyle(.red)
                    Button("Center") {
                        handleAttack()
                        gameModel.state = .center
                    }.foregroundStyle(.blue)
                    Button("Right") {
                        handleAttack()
                        gameModel.state = .right
                    }.foregroundStyle(.red)
                    NavigationLink(
                        "Go to Result",
                        destination: ResultView(
                            rotateScreenModel: rotateScreenModel,
                            path: $path,
                            isFromResult: $isFromResult,
                            resultScore: resultScore
                        )
                    )
                }
                .padding()
                #endif
            })
            .background {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            .overlay(alignment: .topLeading) {
                Text("残り時間: \(countdown)秒")
                    .font(Font.custom("Mimi_font-Regular", size: 24))
                    .foregroundColor(.white)
                    .padding()
            }
            if showResultButton {
                VStack {
                    NavigationLink(destination: ResultView(
                        rotateScreenModel: rotateScreenModel,
                        path: $path,
                        isFromResult: $isFromResult,
                        resultScore: resultScore
                    )) {
                        Text("結果画面へいく")
                            .font(Font.custom("Mimi_font-Regular", size: 24))
                            .padding()
                            .accentColor(Color.white)
                            .frame(width: 250, height: 65)
                            .background(Color.black)
                            .cornerRadius(.infinity)
                    }
                }
                .transition(.opacity) // フェードインのようなアニメーションを追加可能
            }
        }
        .onAppear {
            motionManager.startAccelerometer(interval: 0.1)

            // 1秒遅れてカウントダウンを開始
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                gameCountdownModel.observeCountdown(timeLimit: 15) { remainingTime in
                    countdown = remainingTime
                } completion: {
                    withAnimation {
                        showResultButton = true
                    }
                }
            }
        }
        .onDisappear {
            motionManager.stopAccelerometer()
        }
        .onChange(of: motionManager.accelerometerData) {
            updateGameModelState()
        }
    }
    
    // 加速度データに基づいて NekonoteModel の state と ChuruModel の position を更新
    private func updateGameModelState() {
        guard let y = motionManager.accelerometerData?.acceleration.y else { return }
        
        if y > 0.5 {
            churuModel.updatePosition(x: 1.0)
        } else if y < -0.5 {
            churuModel.updatePosition(x: -1.0)
        } else {
            churuModel.updatePosition(x: 0.0)
        }
    }

    // アタックされたときの処理
    private func handleAttack() {
        withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete) {
            gameModel.isAttacked = true
        } completion: {
            withAnimation(.easeInOut(duration: 0.3)) {
                gameModel.isAttacked = false
            }
        }
        if (gameModel.state.toString() == churuModel.position.rawValue){
            actionAttack()
        } else {
            // 当たっていない時
            resultScore.recordFailure(at: churuModel.position)
        }
    }
    
    private func handleAvoid() {
        resultScore.recordAvoid()
    }
    
    private func actionAttack() {
        let soundNameList = ["attack_1", "attack_2", "attack_3"]
        let randomIndex = Int.random(in: 0..<soundNameList.count)
        let soundName = soundNameList[randomIndex]
        SoundManager.shared.playSound(soundName)

        // バイブレーションも鳴らす
        VibrationManager.shared.triggerNotificationFeedback(type: .success)
        // 回数の保存
        resultScore.recordSuccess(at: churuModel.position)
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
