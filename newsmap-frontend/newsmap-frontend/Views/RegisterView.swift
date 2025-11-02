import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var confirmPassword = ""
    @Environment(\.presentationMode) var presentationMode
    
    private var isRegisterFormValid: Bool {
        !viewModel.username.isEmpty && !viewModel.password.isEmpty && !confirmPassword.isEmpty && viewModel.password == confirmPassword
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Registrati")
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
                        
                        HStack {
                            if isConfirmPasswordVisible {
                                TextField("Conferma Password", text: $confirmPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            } else {
                                SecureField("Conferma Password", text: $confirmPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            Button(action: {
                                isConfirmPasswordVisible.toggle()
                            }) {
                                Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if !isRegisterFormValid && !confirmPassword.isEmpty {
                        Text("Le password non corrispondono")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button {
                        Task { await viewModel.register(confirmPassword: confirmPassword) }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor.opacity(isRegisterFormValid ? 1 : 0.5))
                                .cornerRadius(12)
                        } else {
                            Text("Registrati")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor.opacity(isRegisterFormValid ? 1 : 0.5))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .disabled(!isRegisterFormValid || viewModel.isLoading)
                    
                    Spacer()
                }
                .padding()
                .background(Material.regular)
                .cornerRadius(20)
                .padding()
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $viewModel.registrationSuccess) {
            Alert(
                title: Text("Successo"),
                message: Text("Registrazione avvenuta con successo!"),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

#Preview {
    RegisterView()
}