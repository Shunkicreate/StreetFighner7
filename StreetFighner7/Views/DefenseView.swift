import SwiftUI

struct DefenseView: View {
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        VStack {
            Text("Defense Screen")
                .font(.largeTitle)
            NavigationLink("Go to Result", destination: ResultView(path: $path, isFromResult: $isFromResult))
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}
