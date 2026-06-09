import SwiftUI

struct SignupView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    
    // Flag to trigger navigation to preferences
    @State private var didRegister = false
    // Hold the user’s selected preferences
    @State private var userPreferences: Set<String> = []
    @ObservedObject var profileVM : ProfileViewModel
    
    var loginViewModel: LoginViewModel
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.96, blue: 0.98)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Sign up")
                        .font(.title)
                        .bold()
                    
                    Image("RegisterAdd")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                    
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    SecureField("Choose Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    SecureField("Repeat Password", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Text(errorMessage)
                        .font(.caption).bold()
                        .foregroundColor(.red)
                    
                    Button("Register") {
                        errorMessage = ""
                        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
                            errorMessage = "Invalid Entry."
                            return
                        }
                        guard confirmPassword == password else {
                            errorMessage = "Password does not match."
                            return
                        }
                        
                        // 1) Perform registration
                        loginViewModel.register(String: email, String: password) { success, _ in
                            if success {
                                // 2) Immediately log in
                                loginViewModel.isValid(String: email, String: password) { result, _ in
                                    if result {
                                        // 3) Flip flag to push PreferenceView
                                        didRegister = true
                                    } else {
                                        errorMessage = "Cannot Signup at this time."
                                    }
                                }
                            } else {
                                errorMessage = "Already registered."
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.43, green: 0.48, blue: 0.60))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    
                    Text("By proceeding you also agree to the Terms of Service and Privacy Policy")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                }
                .padding()
            }
            // 4) Once didRegister == true, navigate to PreferenceView
            .navigationDestination(isPresented: $didRegister) {
                PreferenceView(
                    onBack: {
                        // allow user to return to signup
                        didRegister = false
                    },
                    onNext: { prefs in
                        // Save preferences (e.g. via your ViewModel)
                        userPreferences = prefs
                        let data = [
                            "name" : name,
                            "email":email,
                            "preferences": Array(prefs),
                            "invitations" :[]
                        ]
                        let uid = LoginViewModel().getCurrentUser()
                        profileVM.currentUser = UserModel(id:uid , data:data)
                        profileVM.pushUser()
                        isLoggedIn = true
                    }
                )
            }
        }
    }
}
