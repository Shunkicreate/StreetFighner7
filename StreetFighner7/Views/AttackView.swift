import SwiftUI

struct AttackView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @StateObject private var resultScore = ResultScore()
    @StateObject private var motionManager = MotionManager()
    @State private var catHandModel = CatHandModel(position: CatHandDirection.center)
    
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
        }
//        .padding()
//        .navigationBarBackButtonHidden(true)
        .onAppear {
            rotateScreenModel.rotateScreen(orientation: .portrait)
            motionManager.startAccelerometer(interval: 0.1)
            motionManager.startDeviceMotion(interval: 0.1)
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
        var isAttack = motionManager.isAttack;
        var accelerometerData = motionManager.accelerometerData
        var deviceMotionData = motionManager.deviceMotionData
        
        self.catHandModel.updateIsAttack(isAttack: (isAttack ?? false))
            
        if isAttack == false {
            return
        }
       //
       var yaw = (deviceMotionData?.attitude.yaw ?? 90) * 180 / Double.pi
       let _ = print(yaw)
       yaw -= 20
            
       //    if yaw <= -90 {
       //      yaw += 180
       //    }
       //    if yaw >= 90 {
       //      yaw -= 180
       //    }
            
       if(yaw >= 30 && yaw <= 150) {
         self.catHandModel.updateDirection(direction: CatHandDirection.left)
       } else if (yaw <= -30 && yaw >= -150) {
         self.catHandModel.updateDirection(direction: CatHandDirection.right)
       } else {
         self.catHandModel.updateDirection(direction: CatHandDirection.center)
       }
    }
}

#Preview {
    @State var path = NavigationPath()
    @State var isFromResult = false
    return NavigationStack(path: $path) {
        AttackView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult)
    }
}
