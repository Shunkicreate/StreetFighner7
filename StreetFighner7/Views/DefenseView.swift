import SwiftUI

struct DefenseView: View {
    @State private var gameModel = NekonoteModel(state: .center)
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @StateObject private var motionManager = MotionManager() // MotionManagerを使用
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Nekonote状態に応じた画像の表示
                ZStack {
                    if gameModel.state == .left {
                        Image("nekonote_reverse")
                            .resizable()
                            .scaledToFit()
                            .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.3)
                    } else if gameModel.state == .center {
                        Image("nekonote_reverse")
                            .resizable()
                            .scaledToFit()
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.3)
                    } else if gameModel.state == .right {
                        Image("nekonote_reverse")
                            .resizable()
                            .scaledToFit()
                            .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.3)
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
                
                VStack {
                    HStack {
                        Button("Left") {
                            handleAttack()
                            gameModel.state = .left
                        }
                        Button("Center") {
                            handleAttack()
                            gameModel.state = .center
                        }
                        Button("Right") {
                            handleAttack()
                            gameModel.state = .right
                        }
                    }
                    .padding()
                    
                    // 結果画面への遷移リンク
                    NavigationLink("Go to Result", destination: ResultView(path: $path, isFromResult: $isFromResult))
                }
                .padding()
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
    
    // 加速度データに基づいて NekonoteModel の state を更新
    private func updateGameModelState() {
        guard let y = motionManager.accelerometerData?.acceleration.y else { return }
        
        if y > 0.5 {
            gameModel.state = .right
        } else if y < -0.5 {
            gameModel.state = .left
        } else {
            gameModel.state = .center
        }
    }

    // アタックされたときの処理
    private func handleAttack() {
        gameModel.isAttacked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            gameModel.isAttacked = false
        }
    }
}
