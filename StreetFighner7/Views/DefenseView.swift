import SwiftUI
import AVFoundation

// NekonoteとChuruの設定を保持するオブジェクト
struct NekonoteSetting {
    let imageName: String = "nekonote_reverse"
    let concentrationLineImage: String = "concentration_line"
    let positions: [CGFloat] = [0.4, 0.5, 0.7] // 左, 中央, 右の位置
}

struct ChuruSetting {
    let imageName: String = "churu_fukuro"
    let size: CGSize = CGSize(width: 150, height: 150) // Churuのサイズ
    let positions: [CGFloat] = [0.2, 0.5, 0.8] // 左, 中央, 右の位置
}

struct DefenseView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @State private var gameModel = NekonoteModel(state: .center)
    @State private var churuModel = ChuruModel(position: .center)
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @StateObject private var motionManager = MotionManager()
    @State private var audioPlayer: AVAudioPlayer?
    
    // 設定オブジェクトのインスタンス
    private let nekonoteSetting = NekonoteSetting()
    private let churuSetting = ChuruSetting()
    
    // 変数化したアニメーションのduration
    private let animationDuration: Double = 0.3
    private let attackDuration: Double = 0.3
    private let resetDuration: Double = 0.1

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ZStack(alignment: .bottom ) {
                    // Churuの表示
                    ChuruImage(churuModel: churuModel, setting: churuSetting, geometry: geometry)
                    // Nekonoteの表示
                    NekonoteImage(gameModel: gameModel, setting: nekonoteSetting, geometry: geometry, animationDuration: animationDuration)
                }
                
                VStack {
                    HStack {
                        Button("Left") {
                            handleAttack()
                            withAnimation(.easeInOut(duration: animationDuration)) {
                                gameModel.state = .left
                            }
                        }
                        Button("Center") {
                            handleAttack()
                            withAnimation(.easeInOut(duration: animationDuration)) {
                                gameModel.state = .center
                            }
                        }
                        Button("Right") {
                            handleAttack()
                            withAnimation(.easeInOut(duration: animationDuration)) {
                                gameModel.state = .right
                            }
                        }
                        NavigationLink("Go to Result", destination: ResultView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult))
                    }
                    .padding()
                }
                .padding()
                .navigationBarBackButtonHidden(true)
            }
        }
        .onAppear {
            motionManager.startAccelerometer(interval: 0.1)
        }
        .onDisappear {
            motionManager.stopAccelerometer()
        }
        .onChange(of: motionManager.accelerometerData) { _ in
            updateGameModelState()
        }
    }
    
    // 加速度データに基づいて NekonoteModel の state と ChuruModel の position を更新
    private func updateGameModelState() {
        guard let y = motionManager.accelerometerData?.acceleration.y else { return }
        
        if y > 0.5 {
            withAnimation(.easeInOut(duration: resetDuration)) {
                churuModel.updatePosition(x: 1.0)
            }
        } else if y < -0.5 {
            withAnimation(.easeInOut(duration: resetDuration)) {
                churuModel.updatePosition(x: -1.0)
            }
        } else {
            withAnimation(.easeInOut(duration: resetDuration)) {
                churuModel.updatePosition(x: 0.0)
            }
        }
    }

    // アタックされたときの処理
    private func handleAttack() {
        actionAttack()
    }
    
    private func actionAttack() {
        let soundNameList = ["attack_1", "attack_2", "attack_3"]
        let randomIndex = Int.random(in: 0..<soundNameList.count)
        let soundName = soundNameList[randomIndex]
        SoundManager.shared.playSound(soundName)
        
        // アニメーションを開始
        withAnimation(.easeInOut(duration: attackDuration)) {
            gameModel.isAttacked = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + attackDuration) {
            // アニメーション終了後に元の状態に戻す
            withAnimation(.easeInOut(duration: resetDuration)) {
                gameModel.isAttacked = false
            }
        }
    }

}

// Nekonoteの表示コンポーネント
struct NekonoteImage: View {
    let gameModel: NekonoteModel
    let setting: NekonoteSetting
    let geometry: GeometryProxy
    let animationDuration: Double // アニメーションのdurationを外部から受け取る
    
    @State private var scale: CGFloat = 1.0 // 初期スケールは1.0

    var body: some View {
        ZStack {
            let positionIndex = gameModel.state == .left ? 0 : gameModel.state == .center ? 1 : 2
            let xPosition = geometry.size.width * setting.positions[positionIndex]
            
            // Nekonoteの画像にスケーリングアニメーションを適用し、上部を固定
            Image(setting.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width * 0.1) // 画像サイズを明示的に指定
                .position(x: xPosition, y: geometry.size.height * 0.16) // 中央位置に調整
                .scaleEffect(gameModel.isAttacked ? 2.7 : 1.0, anchor: .top) // 上部を固定して拡大
                .animation(.easeInOut(duration: animationDuration), value: gameModel.isAttacked) // スケーリングアニメーション
            
            if gameModel.isAttacked {
                Image(setting.concentrationLineImage)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.5)
                    .ignoresSafeArea()
            }
        }
    }
}

// Churuの表示コンポーネント
struct ChuruImage: View {
    let churuModel: ChuruModel
    let setting: ChuruSetting
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            let positionIndex = churuModel.position == .left ? 0 : churuModel.position == .center ? 1 : 2
            let xPosition = geometry.size.width * setting.positions[positionIndex]
            
            Image(setting.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: setting.size.width, height: setting.size.height)
                .position(x: xPosition, y: geometry.size.height * 0.7) // 固定されたY位置
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
