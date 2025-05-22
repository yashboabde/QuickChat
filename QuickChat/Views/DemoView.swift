import SwiftUI

struct DemoView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, World!")
                
                NavigationLink("Main View", destination: SignupView(isLoggedIn: .constant(true)))
                    .buttonStyle(.borderedProminent)
                    .font(.headline)
            }
        }
    }
}

#Preview {
    DemoView()
}

