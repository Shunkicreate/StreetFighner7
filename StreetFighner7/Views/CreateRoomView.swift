import SwiftUI

struct User: Identifiable {
    let id = UUID()
    let name: String
}

struct CreateRoomView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var users: [User] = [
            User(name: "User1"),
            User(name: "User2"),
            User(name: "User3")
        ]
    // 選択されたユーザー
        @State private var selectedUser: User? = nil
    
    var body: some View {
        NavigationView {
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
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(users) { user in
                                Button(action: {
                                    selectedUser = user
                                }) {
                                    HStack {
                                        Text(user.name)
                                            .font(Font.custom("Mimi_font-Regular", size: 18)) // Reduce the font size
                                            .padding(.vertical, 10) // Adjust vertical padding to make buttons smaller
                                            .padding(.horizontal, 15) // Adjust horizontal padding
                                            .foregroundColor(selectedUser?.id == user.id ? .white : .black)
                                        
                                        Spacer()
                                        
                                        if selectedUser?.id == user.id {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                                .padding(.trailing, 10)
                                        }
                                    }
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8) // Set width to 80% of the screen
                                    .background(selectedUser?.id == user.id ? Color.blue : Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                                    .padding(.horizontal, 10) // Adjust padding to center the buttons
                                }
                            }
                        }
                    }
                    NavigationLink(destination: AttackView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult)) {
                        Text("たたかう")
                            .font(Font.custom("Mimi_font-Regular", size: 24))
                            .padding()
                            .frame(width: 250, height: 65)
                            .background(selectedUser == nil ? Color.gray : Color.black) // Change background to gray if disabled
                            .foregroundColor(selectedUser == nil ? Color.black : Color.white) // Change text color to black if disabled
                            .cornerRadius(.infinity)
                    }
                    .disabled(selectedUser == nil) // Disable button if no user is selected
                    .padding(5)

                }
                .padding()
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
    return CreateRoomView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult)
}
