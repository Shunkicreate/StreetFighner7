import SwiftUI

struct JoinRoomView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    
    @State private var users: [User] = [] // 初期状態は空のリスト
    @State private var selectedUser: User? = nil
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("ねこぱんち")
                    .font(Font.custom("Mimi_font-Regular", size: 96))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                if users.isEmpty {
                    Text("相手をさがしてます")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                } else {
                    Text("\(selectedUser?.name ?? "ユーザー")さんからしょうたい！")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                }
                
                Spacer()

                NavigationLink(destination: DefenseView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult)) {
                    Text("たたかう")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                        .frame(width: 250, height: 65)
                        .background(selectedUser == nil ? Color.gray : Color.black)
                        .foregroundColor(selectedUser == nil ? Color.black : Color.white)
                        .cornerRadius(.infinity)
                }
                .disabled(selectedUser == nil)
                .padding(5)

                Spacer()
                
                // デバッグ用ボタン
                Button("デバッグ: ユーザー追加") {
                    users.append(User(name: "デバッグユーザー"))
                    selectedUser = users.first
                }
                .font(Font.custom("Mimi_font-Regular", size: 18))
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .background {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button {
            dismiss()
        } label: {
            Text("もどる")
                .font(Font.custom("Mimi_font-Regular", size: 30))
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    @State var path = NavigationPath()
    @State var isFromResult = false
    return JoinRoomView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult)
}
