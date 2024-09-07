import SwiftUI

struct JoinRoomView: View {
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        VStack {
            Text("Join Room Screen")
                .font(.largeTitle)
            NavigationLink("Start Game (Defense)", destination: DefenseView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult))
        }
        .padding()
    }
}
