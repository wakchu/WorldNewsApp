import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var confirmPassword = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
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
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Conferma Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
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
                        .background(Color.accentColor)
                        .cornerRadius(12)
                } else {
                    Text("Registrati")
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .disabled(viewModel.isLoading)
            
            Spacer()
        }
        .padding()
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