import SwiftUI
import MultipeerConnectivity

struct JoinRoomView: View {
    @StateObject var joinRoomViewModel = JoinRoomViewModel()
    @ObservedObject var rotateScreenModel: RotateScreenModel
    @Binding var path: NavigationPath
    @Binding var isFromResult: Bool
    /// 対戦相手の情報
    @State private var joinedPeer: PeerDevice?
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

                NavigationLink(destination: DefenseView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult)) {
                    Text("たたかう")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                        .frame(width: 250, height: 65)
                        .background(joinedPeer == nil ? Color.gray : Color.black)
                        .foregroundColor(joinedPeer == nil ? Color.black : Color.white)
                        .cornerRadius(.infinity)
                }
                .disabled(joinedPeer == nil)
                .padding(5)
                
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
