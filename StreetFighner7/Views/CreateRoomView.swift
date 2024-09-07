import SwiftUI

struct CreateRoomView: View {
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        VStack {
            Text("Create Room Screen")
                .font(.largeTitle)
            NavigationLink("Start Game (Attack)", destination: PortraitViewControllerWrapper(content: AttackView(path: $path, isFromResult: $isFromResult)))
        }
        .padding()
    }
}
