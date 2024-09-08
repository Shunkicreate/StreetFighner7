import SwiftUI

struct CreateRoomView: View {
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    @Environment(\.dismiss) var dismiss
    @StateObject var createRoomViewModel = CreateRoomViewModel()
    /// 対戦画面への遷移フラグ
    @State private var isNavigationActive = false
    
    @State private var isShowWarningAlert = false
    
    let columns = [
        GridItem(.flexible(), spacing: 15), // Flexible column
        GridItem(.flexible(), spacing: 15)  // Flexible column
    ]
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Text("ねこぱんち")
                        .font(Font.custom("Mimi_font-Regular", size: 96))
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 7) {
                            ForEach(createRoomViewModel.peers) { peer in
                                Button(action: {
                                    createRoomViewModel.invite(_selectedPeer: peer)
                                }) {
                                    VStack {
                                        HStack {
                                            Text(peer.peerId.displayName)
                                                .font(Font.custom("Mimi_font-Regular", size: 18)) // フォントサイズを小さくする
                                                .padding(.vertical, 10) // ボタンを小さくするために垂直方向の余白を調整
                                                .padding(.horizontal, 15) // 水平方向の余白を調整
                                                .foregroundColor(createRoomViewModel.selectedPeer?.peerId == peer.peerId ? .white : .black)
                                            
                                            Spacer()
                                            
                                            if createRoomViewModel.selectedPeer?.peerId == peer.peerId {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.white)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity) // 幅を無限に設定し、グリッドの各列に合わせる
                                    .background(createRoomViewModel.selectedPeer?.peerId == peer.peerId ? Color.blue : Color.white)
                                    .cornerRadius(15)
                                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                                    .padding(.horizontal, 10) // ボタンを中央に配置するために余白を調整
                                }
                            }
                        }
                        //                    .padding(.horizontal, 10) // グリッド全体の左右の余白を調整
                    }
                    .frame(height: geometry.size.height * 0.5)
                    
                    Button(action:{
                        createRoomViewModel.join()
                        createRoomViewModel.send(message: .init(type: .start, message: ""))
                        isNavigationActive = true
                    }) {
                        Text("たたかう")
                            .font(Font.custom("Mimi_font-Regular", size: 24))
                            .padding()
                            .frame(width: 250, height: 65)
                            .background(createRoomViewModel.sessionState != .connected || isShowWarningAlert ? Color.gray : Color.black)
                            .foregroundColor(createRoomViewModel.sessionState != .connected || isShowWarningAlert ? Color.black : Color.white)
                            .cornerRadius(.infinity)
                    }
                    .disabled(createRoomViewModel.sessionState != .connected || isShowWarningAlert)
                    .padding(5)
                    NavigationLink(destination: AttackView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult, createRoomViewModel: createRoomViewModel), isActive: $isNavigationActive) {
                        EmptyView()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .onAppear {
            rotateScreenModel.rotateScreen(orientation: .portrait)
        }
        .onChange(of: createRoomViewModel.sessionState) {
            if createRoomViewModel.sessionState == .connected {
                isShowWarningAlert = true
            }
        }
        .alert("スマホを縦に持ってください", isPresented: $isShowWarningAlert) {
            Button {
            } label: {
                Text("わかりました")
            }
        }
    }
    var backButton: some View {
        Button {
            rotateScreenModel.rotateScreen(orientation: .landscape)
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
