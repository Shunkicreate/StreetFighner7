import SwiftUI

struct AttackView: View {
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        VStack {
            Text("Attack Screen")
                .font(.largeTitle)
            NavigationLink("Go to Result", destination: ResultView(path: $path, isFromResult: $isFromResult))
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
