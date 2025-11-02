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
            Color(.systemGray6).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("WorldNewsMap")
                        .font(.custom("BBHSansHegarty-Regular", size: 34))
                        .padding(.top, 60)
                        .foregroundColor(.accentColor)
                    
                    VStack(spacing: 16) {
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.default)
                            .autocapitalization(.none)
                        
                        HStack {
                            if isPasswordVisible {
                                TextField("Password", text: $viewModel.password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                SecureField("Password", text: $viewModel.password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
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
                                .foregroundColor(.primary)
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
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .padding()
                .background(Material.regular)
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
