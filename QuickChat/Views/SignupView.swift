import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    // For dismissing the view
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 16) {
                        // Email Field
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                        
                        // Password Field
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        // Confirm Password Field
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        // Sign Up Button
                        Button(action: signUp) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign Up")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!formIsValid)
                        
                        NavigationLink("Already have an account? Log In", destination: LoginView())
                            .navigationBarBackButtonHidden(true)
                        
                        // Error/Success Messages
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        
                        if let successMessage = successMessage {
                            Text(successMessage)
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
        }
    }
    
    // Form validation
    private var formIsValid: Bool {
        return !email.isEmpty &&
               email.contains("@") &&
               !password.isEmpty &&
               password == confirmPassword &&
               password.count >= 6 &&
               !isLoading
    }
    
    private func signUp() {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        // Additional client-side validation
        guard password == confirmPassword else {
            errorMessage = "Passwords don't match"
            isLoading = false
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            isLoading = false
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            isLoading = false
            
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            
            // Successfully created account
            successMessage = "Account created successfully!"
            
            // You might want to automatically sign in the user here
            // or send a verification email:
            sendEmailVerification()
            
            // Optionally dismiss after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
        }
    }
    
    private func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification { error in
            if let error = error {
                errorMessage = "Couldn't send verification email: \(error.localizedDescription)"
            } else {
                successMessage = "Verification email sent to \(email). Please check your inbox."
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(isLoggedIn: .constant(false)) // ✅ Fixed preview
    }
}

