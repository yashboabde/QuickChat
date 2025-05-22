import SwiftUI

struct ChatsView: View {
    @StateObject private var viewModel = ChatsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.chats) { chat in
                HStack {
                    AsyncImage(url: URL(string: chat.otherUserImageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(chat.otherUserName)
                            .font(.headline)
                        Text(chat.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text(timeAgo(from: chat.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Chats")
            .onAppear {
                viewModel.fetchChats()
            }
        }
    }
    
    func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    ChatsView()
}
