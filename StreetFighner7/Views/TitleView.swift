import SwiftUI

struct TitleView: View { 
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    var body: some View {
        ZStack {
            // 背景画像を追加
            Image("background")
                .resizable() // 画像をリサイズ可能にする
                .scaledToFill() // 画像をフレーム全体にフィットさせる
                .ignoresSafeArea() // セーフエリアを無視して全画面に表示する

            // 他のUIコンポーネントを配置
            VStack {
                Text("Title Screen")
                    .font(.largeTitle)
                NavigationLink("Create Room", destination: CreateRoomView(path: $path, isFromResult: $isFromResult))
                NavigationLink("Join Room", destination: JoinRoomView(path: $path, isFromResult: $isFromResult))
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            
        }
    }
}
