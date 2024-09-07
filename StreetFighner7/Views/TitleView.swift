import SwiftUI

struct TitleView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        VStack {
            Text("ねこぱんち")
                .font(Font.custom("Mimi_font-Regular", size: 96))
            
            // 他のUIコンポーネントを配置
            VStack {
                Text("ねこぱんち")
                    .font(Font.custom("Mimi_font-Regular", size: 96))
                
                NavigationLink(destination: CreateRoomView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult)) {
                    Text("へやをつくる")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                        .accentColor(Color.white)
                        .frame(width: 250, height: 65)
                        .background(Color.black)
                        .cornerRadius(.infinity)
                }
                .padding(10)
                
                NavigationLink(destination: JoinRoomView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult)) {
                    Text("へやにはいる")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                        .accentColor(Color.white)
                        .frame(width: 250, height: 65)
                        .background(Color.black)
                        .cornerRadius(.infinity)
                }
                .padding(5)
                
                NavigationLink(destination: PunchTestView()) {
                    Text("へやにはいる")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                        .accentColor(Color.white)
                        .frame(width: 250, height: 65)
                        .background(Color.black)
                        .cornerRadius(.infinity)
                }
                .padding(5)
                .padding(5)
            }
            .padding(10)
            
            NavigationLink(destination: JoinRoomView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult)) {
                Text("へやにはいる")
                    .font(Font.custom("Mimi_font-Regular", size: 24))
                    .padding()
                    .accentColor(Color.white)
                    .frame(width: 250, height: 65)
                    .background(Color.black)
                    .cornerRadius(.infinity)
            }
            .padding(5)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    @State var path = NavigationPath()
    @State var isFromResult = false
    return NavigationStack(path: $path) {
        TitleView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult)
    }
}
