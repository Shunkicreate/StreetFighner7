import SwiftUI

struct ResultView: View {
    var body: some View {
        VStack {
            Text("Result Screen")
                .font(.largeTitle)
            Text("Defense Screen")
                .font(.largeTitle)
            NavigationLink("Back to Title", destination: TitleView())
        }
        .padding()
    }
}
