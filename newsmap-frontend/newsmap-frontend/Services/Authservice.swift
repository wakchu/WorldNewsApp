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
    let token: String
}

class AuthService {
    private let apiService = APIService()
    
    func login(username: String, password: String) async throws -> Bool {
        let body = LoginRequest(username: username, password: password)
        let response: LoginResponse = try await apiService.post(endpoint: "/api/auth/login", body: body)
        KeychainHelper.standard.save(response.token, service: "auth", account: "jwt")
        return true
    }
    
    func register(username: String, password: String) async throws -> Bool {
        let body = RegisterRequest(username: username, password: password)
        try await apiService.postEmpty(endpoint: "/api/auth/register", body: body)
        return true
    }
}
