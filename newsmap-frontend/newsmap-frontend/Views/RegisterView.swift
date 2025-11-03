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
                        
                        ZStack(alignment: .trailing) {
                            if isConfirmPasswordVisible {
                                TextField("Conferma Password", text: $confirmPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 41/255, green: 41/255, blue: 41/255), lineWidth: 1)
                                    )
                            } else {
                                SecureField("Conferma Password", text: $confirmPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(red: 41/255, green: 41/255, blue: 41/255), lineWidth: 1)
                                    )
                            }
                            Button(action: {
                                isConfirmPasswordVisible.toggle()
                            }) {
                                Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
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
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor.opacity(isRegisterFormValid ? 1 : 0.5))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .disabled(!isRegisterFormValid || viewModel.isLoading)

                    Button("Torna al Login") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.footnote)
                    .foregroundColor(Color(red: 41/255, green: 41/255, blue: 41/255))
                    .padding(.top, 8)
                    
                    Spacer()
                }
                .padding()
                
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