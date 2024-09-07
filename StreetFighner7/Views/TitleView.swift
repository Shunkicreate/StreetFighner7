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
                Text("ねこぱんち")
                    .font(Font.custom("Mimi_font-Regular", size: 96))
                
                Button {
                    
                } label: {
                    Text("へやをつくる")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                        .accentColor(Color.white)
                        .frame(width: 300)
                        .background(Color.black)
                        .cornerRadius(.infinity)
                }
                .padding(10)
                
                Button {
                   
                } label: {
                    Text("へやにはいる")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                        .accentColor(Color.white)
                        .frame(width: 300)
                        .background(Color.black)
                        .cornerRadius(.infinity)
                }
                .padding(5)
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            
        }
    }
}

#Preview {
    TitleView()
}
