import SwiftUI

struct DefenseView: View {
    var body: some View {
        VStack {
            Text("Defense Screen")
                .font(.largeTitle)
            NavigationLink("Go to Result", destination: ResultView())
        }
        .padding()
    }
}
