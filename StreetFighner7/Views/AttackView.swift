import SwiftUI

struct AttackView: View {
    var body: some View {
        VStack {
            Text("Attack Screen")
                .font(.largeTitle)
            NavigationLink("Go to Result", destination: ResultView())
        }
        .padding()
    }
}
