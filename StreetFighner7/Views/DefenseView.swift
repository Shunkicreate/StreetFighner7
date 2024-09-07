import SwiftUI

struct DefenseView: View {
    @State private var gameModel = NekonoteModel(state: .center)
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ZStack {
                    if gameModel.state == .left {
                        Image("nekonote_reverse")
                            .resizable()
                            .scaledToFit()
                            .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.3)
                    } else if gameModel.state == .center {
                        Image("nekonote_reverse")
                            .resizable()
                            .scaledToFit()
                            .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.3)
                    } else if gameModel.state == .right {
                        Image("nekonote_reverse")
                            .resizable()
                            .scaledToFit()
                            .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.3)
                    }
                }
                
                VStack {
                    HStack {
                        Button("Left") {
                            gameModel.state = .left
                        }
                        Button("Center") {
                            gameModel.state = .center
                        }
                        Button("Right") {
                            gameModel.state = .right
                        }
                        NavigationLink("Go to Result", destination: ResultView(path: $path, isFromResult: $isFromResult))
                    }
                    .padding()
                }
                .padding()
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}
