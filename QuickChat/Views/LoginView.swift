import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn: Bool = false
    
    // For dismissing the view
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            NavigationStack {
                
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Login to Your Existing Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 16) {
                        // Email Field
                        TextField("Email", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                        
                        // Password Field
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        // Log In Button
                        Button(action: signIn) {
                            Text("Log In")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, minHeight: 50)
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(username.isEmpty || password.isEmpty)
                        NavigationLink("New User? Sign Up", destination: SignupView(isLoggedIn: $isLoggedIn))
                            .navigationBarBackButtonHidden(true)
                        
                        // Error Message
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Success Message
                        if isLoggedIn {
                            Text("✅ Login Successful!")
                                .foregroundColor(.green)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(
                isPresented: $isLoggedIn,
                destination: { ChatsView() }
            )
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = "Login failed: \(error.localizedDescription)"
                return
            }

            self.errorMessage = nil
            self.isLoggedIn = true
            print("Login successful: \(authResult?.user.email ?? "unknown")")
            
            // Optionally dismiss after successful login
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}

