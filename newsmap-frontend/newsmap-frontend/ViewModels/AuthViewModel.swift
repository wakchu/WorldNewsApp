import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    
    private let authService = AuthService()
    
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Inserisci email e password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let success = try await authService.login(email: email, password: password)
            if success {
                isLoggedIn = true
            } else {
                errorMessage = "Credenziali non valide"
            }
        } catch {
            errorMessage = "Errore di connessione: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func register(confirmPassword: String) async {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Inserisci email, password e conferma password"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Le password non corrispondono"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let success = try await authService.register(email: email, password: password)
            if success {
                isLoggedIn = true
            } else {
                errorMessage = "Registrazione fallita"
            }
        } catch {
            errorMessage = "Errore di connessione: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
