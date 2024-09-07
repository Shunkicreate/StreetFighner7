import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack {
            Text("Title Screen")
                .font(.largeTitle)
            NavigationLink("Create Room", destination: CreateRoomView())
            NavigationLink("Join Room", destination: JoinRoomView())
        }
        .padding()
    }
}
