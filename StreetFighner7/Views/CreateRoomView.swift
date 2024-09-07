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
    @ObservedObject var viewModel = CreateRoomViewModel()
    @State var isPleaseWaitAlertActive: Bool = false
    @State private var isNavigationActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("ねこぱんち")
                    .font(Font.custom("Mimi_font-Regular", size: 96))
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.peers) { peer in
                            Button(action: {
                                viewModel.invite(_selectedPeer: peer)
                            }) {
                                HStack {
                                    Text(peer.peerId.displayName)
                                        .font(Font.custom("Mimi_font-Regular", size: 18)) // Reduce the font size
                                        .padding(.vertical, 10) // Adjust vertical padding to make buttons smaller
                                        .padding(.horizontal, 15) // Adjust horizontal padding
                                        .foregroundColor(viewModel.selectedPeer?.peerId == peer.peerId ? .white : .black)
                                    
                                    Spacer()
                                    
                                    if viewModel.selectedPeer?.peerId == peer.peerId {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .padding(.trailing, 10)
                                    }
                                }
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.8) // Set width to 80% of the screen
                                .background(viewModel.selectedPeer?.peerId == peer.peerId ? Color.blue : Color.white)
                                .cornerRadius(15)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                                .padding(.horizontal, 10) // Adjust padding to center the buttons
                            }
                        }
                    }
                }
                Button(action:{
                    // 条件をチェックして、遷移を許可するかを決定
                    if (!viewModel.isParticipantsJoined()) {
                        isPleaseWaitAlertActive = true
                        return
                    }
                    viewModel.join()
                    isNavigationActive = true
                }) {
                    Text("たたかう")
                        .font(Font.custom("Mimi_font-Regular", size: 24))
                        .padding()
                        .frame(width: 250, height: 65)
                        .background(viewModel.selectedPeer == nil ? Color.gray : Color.black) // Change background to gray if disabled
                        .foregroundColor(viewModel.selectedPeer == nil ? Color.black : Color.white) // Change text color to black if disabled
                        .cornerRadius(.infinity)
                }
                .disabled(viewModel.selectedPeer == nil) // Disable button if no user is selected
                .padding(5)
                .alert(isPresented: $isPleaseWaitAlertActive, content: {
                    Alert(
                        title: Text("まだその時ではないニャ"),
                        dismissButton: .default(Text("OK"), action: {
                            isPleaseWaitAlertActive = false
                        })
                    )
                })
                NavigationLink(destination: AttackView(rotateScreenModel: rotateScreenModel, path: $path, isFromResult: $isFromResult), isActive: $isNavigationActive) {
                    EmptyView()
                }
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
    return CreateRoomView(rotateScreenModel: .init(), path: $path, isFromResult: $isFromResult)
}
