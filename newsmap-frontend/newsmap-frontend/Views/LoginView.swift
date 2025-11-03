import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    @State private var isPasswordVisible = false
    @State private var showRegisterView = false
    
    private var isLoginFormValid: Bool {
        !viewModel.username.isEmpty && !viewModel.password.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color(red: 56/255, green: 182/255, blue: 255/255).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 250)
                        .padding(.top, 60)
                    
                    VStack(spacing: 16) {
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.default)
                            .autocapitalization(.none)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 41/255, green: 41/255, blue: 41/255), lineWidth: 1)
                            )
                        
                        ZStack(alignment: .trailing) {
                            if isPasswordVisible {
                                TextField("Password", text: $viewModel.password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 41/255, green: 41/255, blue: 41/255), lineWidth: 1)
                                    )
                            } else {
                                SecureField("Password", text: $viewModel.password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 41/255, green: 41/255, blue: 41/255), lineWidth: 1)
                                    )
                            }
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button {
                        Task { await viewModel.login() }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor.opacity(isLoginFormValid ? 1 : 0.5))
                                .cornerRadius(12)
                        } else {
                            Text("Accedi")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor.opacity(isLoginFormValid ? 1 : 0.5))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .disabled(!isLoginFormValid || viewModel.isLoading)
                    
                    Button("Registrati") {
                        showRegisterView.toggle()
                    }
                    .font(.footnote)
                    .foregroundColor(Color(red: 41/255, green: 41/255, blue: 41/255))
                    
                    Spacer()
                }
                .padding()
                
                .cornerRadius(20)
                .padding()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showRegisterView) {
            RegisterView()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
