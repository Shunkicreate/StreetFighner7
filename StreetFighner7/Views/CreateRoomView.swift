import SwiftUI

struct CreateRoomView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        VStack {
            Text("Create Room Screen")
                .font(.largeTitle)
            NavigationLink("Start Game (Attack)", destination: AttackView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult))
        }
        .padding()
    }
}
