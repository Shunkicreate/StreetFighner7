import SwiftUI
import AVFoundation

struct DefenseView: View {
    @State private var gameModel = NekonoteModel(state: .center)
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    @State private var audioPlayer: AVAudioPlayer?
    
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
                        NavigationLink("Go to Result", destination: ResultView(path: $path, isFromResult: $isFromResult))
                    }
                    .padding()
                }
                .padding()
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func handleAttack() {
        actionAttack()
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
        
        // アタックされたときの処理
        gameModel.isAttacked = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            gameModel.isAttacked = false
        }
    }
}
