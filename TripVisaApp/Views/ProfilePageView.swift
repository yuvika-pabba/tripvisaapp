import SwiftUI

struct ProfilePageView: View {
  // MARK: – Dependencies
  @Binding var isLoggedIn: Bool

  // MARK: – ViewModel + State
  @StateObject private var profileVM = ProfileViewModel()
  @State private var isEditing       = false
  @State private var name            = ""
  @State private var email           = ""
  @State private var selectedPrefs: Set<String> = []
  @State private var newPassword     = ""
  @State private var confirmPassword = ""
  @State private var errorMessage: String?

  // MARK: – Preference icons
  private let categoryIcons: [String:String] = [
    "Beach":      "sun.max.fill",
    "Mountain":   "mountain.2.fill",
    "City":       "building.2.fill",
    "Historical": "book.closed.fill",
    "Adventure":  "map.fill",
    "Nature":     "leaf.fill",
    "Cultural":   "theatermasks.fill",
    "Relaxation": "bed.double.fill"
  ]
  private var categories: [String] { Array(categoryIcons.keys) }
  private var visibleCategories: [String] {
    isEditing ? categories
              : categories.filter { selectedPrefs.contains($0) }
  }

  var body: some View {
      NavigationStack {
          ZStack { Color(red: 0.95, green: 0.96, blue: 0.98)
                  .ignoresSafeArea()
              
              ScrollView {
                  VStack(spacing: 30) {
                      profileInfoSection
                      preferencesSection
                      
                      if isEditing {
                          passwordSection
                      } else {
                          signOutButton
                      }
                      
                  }
                  .padding(.top)
              }
              .navigationTitle("My Profile")
              .toolbar {
                  ToolbarItem(placement: .navigationBarTrailing) {
                      Button(isEditing ? "Save" : "Edit", action: toggleEditSave)
                  }
              }
              .onAppear(perform: loadUser)
          }
      }
  }

  // MARK: – Subviews

  private var profileInfoSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Profile Info").font(.headline).padding(.horizontal)

      Group {
        if isEditing {
          TextField("Name", text: $name)
          TextField("Email", text: $email)
            .keyboardType(.emailAddress)
        } else {
          HStack { Text("Name"); Spacer(); Text(name).foregroundColor(.gray) }
          HStack { Text("Email"); Spacer(); Text(email).foregroundColor(.gray) }
        }
      }
      .padding()
      .background(Color.white)
      .cornerRadius(12)
      .padding(.horizontal)
    }
  }

  private var preferencesSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Preferences").font(.headline).padding(.horizontal)

      LazyVGrid(
        columns: [GridItem(.flexible()), GridItem(.flexible())],
        spacing: 16
      ) {
        ForEach(visibleCategories, id: \.self) { cat in
          preferenceCard(for: cat)
            .disabled(!isEditing)
        }
      }
      .padding(.horizontal)
    }
  }

  private var passwordSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Change Password").font(.headline).padding(.horizontal)

      SecureField("New Password",     text: $newPassword)
        .padding().background(Color.white).cornerRadius(12)
        .padding(.horizontal)

      SecureField("Confirm Password", text: $confirmPassword)
        .padding().background(Color.white).cornerRadius(12)
        .padding(.horizontal)

      if let err = errorMessage {
        Text(err).foregroundColor(.red).font(.caption)
          .padding(.horizontal)
      }
    }
    .padding(.top)
  }

  private var signOutButton: some View {
    Button("Sign out") {
        LoginViewModel().logout(){ success in
            if success {
                isLoggedIn = false
            }else{
                print("No Network")
            }
        }  // ignore the callback here
      
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color(red: 0.43, green: 0.48, blue: 0.60))
    .foregroundColor(.white)
    .cornerRadius(25)
    .padding(.horizontal)
  }

  // MARK: – Helpers

  private func preferenceCard(for category: String) -> some View {
    let isSelected = selectedPrefs.contains(category)
    return VStack(spacing: 12) {
      Image(systemName: categoryIcons[category]!)
        .resizable()
        .scaledToFit()
        .frame(width: 36, height: 36)
        .padding(.top, 10)
        .foregroundColor(isSelected ? .accentColor : .gray)

      Text(category)
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .padding(.bottom, 10)
        .foregroundColor(.primary)
    }
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(isSelected ? Color.accentColor : .clear, lineWidth: 2)
    )
    .onTapGesture {
      if isSelected { selectedPrefs.remove(category) }
      else           { selectedPrefs.insert(category) }
    }
  }

  private func toggleEditSave() {
    if isEditing {
      // 1) Validate
      guard newPassword.isEmpty || newPassword == confirmPassword else {
        errorMessage = "Passwords don’t match"
        return
      }
        let loginVM = LoginViewModel()
        if !newPassword.isEmpty || !confirmPassword.isEmpty{
            loginVM.changePassword(password:newPassword){
                success in
                if success{
                    print("Changed Password")
                }else{
                    print("Network Password Error")
                    errorMessage="Network Error to change password"
                }
            }
        }
      // 2) Persist
        Task{
            let currentUser = await profileVM.getCurrentUser()
            let id = loginVM.getCurrentUser()
            let invitations = currentUser["invitations"] ?? []
            let datas: [String: Any] = ["name":name,"email":email, "preferences":Array(selectedPrefs),"invitations":invitations]
            
            profileVM.currentUser = UserModel(id:id , data:datas)
            profileVM.pushUser()
            errorMessage = nil
        }
    }
    // 3) Flip mode
    isEditing.toggle()
  }

  private func loadUser() {
    Task {
      let user = await profileVM.getCurrentUser()
      name            = user["name"] as? String ?? ""
      email           = user["email"] as? String ?? ""
      selectedPrefs   = Set(user["preferences"] as? [String] ?? [])
    }
  }
}


