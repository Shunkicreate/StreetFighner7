import SwiftUI
import MultipeerConnectivity

struct JoinRoomView: View {
    @StateObject var joinRoomViewModel = JoinRoomViewModel()
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    /// 対戦相手の情報
    @State private var joinedPeer: PeerDevice?
    /// 対戦画面への遷移フラグ
    @State private var isNavigationActive = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("ねこぱんち")
                    .font(Font.custom("Mimi_font-Regular", size: 96))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                if joinRoomViewModel.joinedPeer.isEmpty {
                    Text("相手をさがしてます")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                }
                if let joinedPeer = joinedPeer {
                    Text("\(joinedPeer.peerId.displayName)さんからしょうたい！！")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                }

                Spacer()

                NavigationLink(destination: DefenseView(rotateScreenModel: rotateScreenModel, joinRoomViewModel: joinRoomViewModel, path: $path, isFromResult: $isFromResult), isActive: $isNavigationActive) {
                    Text(joinRoomViewModel.messages.first(where: {
                        $0.type == .ready
                    })?.type == .ready ? "かいしをまっています！" : "じゅんびちゅう、、、")
                    .font(Font.custom("Mimi_font-Regular", size: 24))
                    .padding()
                    .frame(width: 250, height: 65)
                    .background(Color.gray)
                    .foregroundColor(Color.black)
                    .cornerRadius(.infinity)
                }
                .disabled(true)
                .padding(5)
                Spacer()
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
        .alert(item: $joinRoomViewModel.permissionRequest, content: { request in
            Alert(
                title: Text("\(request.peerId.displayName)と対戦しますか？"),
                primaryButton: .default(Text("はい"), action: {
                    request.onRequest(true)
                    joinRoomViewModel.join(peer: PeerDevice(peerId: request.peerId))
                    guard let joinedPeer = joinRoomViewModel.joinedPeer.first else {
                        return
                    }
                    self.joinedPeer = joinedPeer
                }),
                secondaryButton: .cancel(Text("いいえ"), action: {
                    request.onRequest(false)
                })
            )
        })
        .onChange(of: joinRoomViewModel.messages) {
            if joinRoomViewModel.messages.first(where: { $0.type == .start }) != nil {
                isNavigationActive = true
            }
        }
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
