import SwiftUI

struct DefenseView: View {
    @State private var gameModel = NekonoteModel(state: .center)
    @State private var isAttacked = false // 新しい状態
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
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
                    if isAttacked {
                        Image("concentration_line")
                            .resizable()
                            .scaledToFill()
                            .opacity(0.5) // 半透明にして重ね合わせる
                            .ignoresSafeArea()
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
        // アタックされたときの処理
        isAttacked = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isAttacked = false
        }
    }
}
