import SwiftUI

struct AttackView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @StateObject private var resultScore = ResultScore()
    @StateObject private var motionManager = MotionManager()
    @StateObject private var gameCountdownModel = GameCountdownModel()
    @State private var catHandModel = CatHandModel(position: CatHandDirection.center)
    @State private var countdown: Int = 15
    @State private var showResultButton = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if 1 == 1 {
                    if catHandModel.direction == .left {
                        Image("nekonote_reverse")
                            .resizable()
                            .scaledToFit()
                            .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.4)
                    } else if catHandModel.direction == .center {
                        Image("nekonote_reverse")
                            .resizable()
                            .scaledToFit()
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.4)
                    } else if catHandModel.direction == .right {
                        Image("nekonote_reverse")
                            .resizable()
                            .scaledToFit()
                            .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.4)
                    }
                    // アタック時のオーバーレイ
                    ZStack {
                        Image("concentration_line")
                            .resizable()
                            .scaledToFill()
                            .opacity(0.5) // 半透明にして重ね合わせる
                            .ignoresSafeArea()
                    }
                } else {
                    VStack {
                        Text("Attack Screen")
                            .font(.largeTitle)
                        NavigationLink(destination: ResultView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult, resultScore: resultScore)) {
                            Text("り ざ る と")
                                .font(Font.custom("Mimi_font-Regular", size: 24))
                                .padding()
                                .accentColor(Color.white)
                                .frame(width: 250, height: 65)
                                .background(Color.black)
                                .cornerRadius(.infinity)
                        }
                    }
                }
            }
            .overlay(alignment: .topLeading) {
                            Text("残り時間: \(countdown)秒")
                                .font(Font.custom("Mimi_font-Regular", size: 24))
                                .foregroundColor(.black)
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
        //        .padding()
        //        .navigationBarBackButtonHidden(true)
        .onAppear {
            rotateScreenModel.rotateScreen(orientation: .portrait)
            motionManager.startAccelerometer(interval: 0.1)
            motionManager.startDeviceMotion(interval: 0.1)
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
            rotateScreenModel.rotateScreen(orientation: .landscapeLeft)
            motionManager.stopAccelerometer()
            motionManager.stopDeviceMotion()
        }
        .onChange(of: motionManager.accelerometerData) { _ in
            updateCatHandModel() // 加速度データが変わるたびに状態を更新
        }
    }
    
    private func updateCatHandModel() {
        let zThreshold: Double = 0.04
        
        var accelerometerData = motionManager.accelerometerData
        var deviceMotionData = motionManager.deviceMotionData
        
        if catHandModel.isAttacking == false {
            catHandModel.isAttack = false;
            if
                (fabs(catHandModel.previousZ ?? 0) > zThreshold),
                catHandModel.previousZ ?? 0 > 0 && accelerometerData?.acceleration.z ?? 0 < 0 {
                print("isAttacking",  catHandModel.previousZ)
                catHandModel.updateIsAttacking(isAttacking: true)
            }
        } else {
            //スマホがほぼ下に向いたら判定
            // trueのままになる問題がある
            if fabs(deviceMotionData?.attitude.pitch ?? 90) < 87 {
                var yaw = (deviceMotionData?.attitude.yaw ?? 90) * 180 / Double.pi
                let _ = print(yaw)
                 yaw -= 10
                     
                //    if yaw <= -90 {
                //      yaw += 180
                //    }
                //    if yaw >= 90 {
                //      yaw -= 180
                //    }
                     
                 if(yaw >= 25 && yaw <= 155) {
                  self.catHandModel.updateDirection(direction: CatHandDirection.left)
                 } else if (yaw <= -25 && yaw >= -125) {
                  self.catHandModel.updateDirection(direction: CatHandDirection.right)
                 } else {
                  self.catHandModel.updateDirection(direction: CatHandDirection.center)
                 }
                
                var isAttack = motionManager.isAttack;
        
                self.catHandModel.updateIsAttack(isAttack: (isAttack ?? false))

                catHandModel.updateIsAttacking(isAttacking: false)
            } else {
                //加速度が重力以外なさそうだったらfalseにする
            }
        }
        
//        var isAttack = motionManager.isAttack;
//        
//        self.catHandModel.updateIsAttack(isAttack: (isAttack ?? false))
//            
//        if isAttack == false {
//            return
//        }
       //
               
        catHandModel.updatePreviousZ(previousZ: accelerometerData?.acceleration.z ?? 0)
    }
}

#Preview {
    @State var path = NavigationPath()
    @State var isFromResult = false
    return NavigationStack(path: $path) {
        AttackView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult)
    }
}
