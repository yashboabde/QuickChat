import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                ChatsView()
            } else {
                SignupView(isLoggedIn: $isLoggedIn) // Pass binding to allow login
            }
        }
    }
}

