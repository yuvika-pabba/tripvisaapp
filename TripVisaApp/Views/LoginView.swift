import SwiftUI

struct LoginView: View {
    @State private var email  = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Binding var isLoggedIn : Bool
    var loginViewModel : LoginViewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.95, green: 0.96, blue: 0.98)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Login")
                        .font(.largeTitle)
                        .foregroundColor(Color(red: 0.13, green: 0.35, blue: 0.13))
                    Text("Welcome To TripVisa")
                        .font(.title3)
                        .foregroundColor(Color(red: 0.13, green: 0.35, blue: 0.13))

                    TextField("Email*", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)

                    SecureField("Password*", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Text(errorMessage).fontWeight(.bold).font(.caption).foregroundColor(.red)
                        Button("Sign in") {
                            loginViewModel.isValid(String: email,String : password){ success, message in
                                if (success){
                                    isLoggedIn = true
                                }else{
                                    isLoggedIn = false
                                    self.errorMessage = "Invalid Cerdential"
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.43, green: 0.48, blue: 0.60))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    

                    Text("OR")
                        .foregroundColor(.gray)

                    NavigationLink(destination: SignupView(profileVM: ProfileViewModel(),loginViewModel: loginViewModel, isLoggedIn: $isLoggedIn )) {
                        Text("Register")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.43, green: 0.48, blue: 0.60))
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                }
                .padding()
            }
        }
    }
}
