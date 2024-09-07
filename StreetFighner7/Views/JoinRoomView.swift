import SwiftUI

struct JoinRoomView: View {
    var body: some View {
        VStack {
            Text("Join Room Screen")
                .font(.largeTitle)
            NavigationLink("Start Game (Defense)", destination: DefenseView())
        }
        .padding()
    }
}
