import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("WorldNewsMap")
                    .font(.custom("BBHSansHegarty-Regular", size: 34))
                    .padding(.top, 60)
                    .foregroundColor(.accentColor)

                
                VStack(spacing: 16) {
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
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
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    } else {
                        Text("Accedi")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .disabled(viewModel.isLoading)
                
                NavigationLink("Registrati", destination: RegisterView())
                    .font(.footnote)
                    .padding(.top, 8)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
