import SwiftUI

struct CreateRoomView: View {
    var body: some View {
        VStack {
            Text("Create Room Screen")
                .font(.largeTitle)
            NavigationLink("Start Game (Attack)", destination: AttackView())
        }
        .padding()
    }
}