import SwiftUI

struct AttackView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        VStack {
            Text("Attack Screen")
                .font(.largeTitle)
            NavigationLink(destination: ResultView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult)) {
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
    }
}

#Preview {
    @State var path = NavigationPath()
    @State var isFromResult = false
    return NavigationStack(path: $path) {
        AttackView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult)
    }
}
