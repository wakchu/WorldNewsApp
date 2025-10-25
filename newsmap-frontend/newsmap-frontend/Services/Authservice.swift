import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let jwt: String
}

class AuthService {
    private let apiService = APIService()
    
    func login(username: String, password: String) async throws -> Bool {
        print("AuthService: login started for user: \(username)")
        let body = LoginRequest(username: username, password: password)
        do {
            print("AuthService: Calling apiService.post for login...")
            let response: LoginResponse = try await apiService.post(endpoint: "/api/auth/login", body: body)
            print("AuthService: apiService.post for login returned.")
            KeychainHelper.standard.save(response.jwt, service: "auth", account: "jwt")
            print("AuthService: Token saved. Login successful.")
            return true
        } catch {
            print("AuthService: Error during login: \(error.localizedDescription)")
            throw error
        }
    }
    
    func register(username: String, password: String) async throws -> Bool {
        let body = RegisterRequest(username: username, password: password)
        try await apiService.postEmpty(endpoint: "/api/auth/register", body: body)
        return true
    }
}
