import SwiftUI

struct AttackView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @StateObject private var resultScore = ResultScore()
    @StateObject private var motionManager = MotionManager()
    @State private var CatHandModel = (isAttack: false, position: CatHandDirection.center)
    
    var body: some View {
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
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            rotateScreenModel.rotateScreen(orientation: .portrait)
        }
        .onDisappear {
            rotateScreenModel.rotateScreen(orientation: .landscapeLeft)
        }
        .onChange(of: motionManager.accelerometerData) { _ in
            updateCatHandModel() // 加速度データが変わるたびに状態を更新
        }
    }
    
    private func updateCatHandModel() {
        var isAttack = motionManager.isAttack;
        var deviceMotionData = motionManager.deviceMotionData
        
    }
}

#Preview {
    @State var path = NavigationPath()
    @State var isFromResult = false
    return NavigationStack(path: $path) {
        AttackView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult)
    }
}
