import Foundation

struct CountryResponse: Decodable {
    let code: String
    let name: String
    let latitude: Double
    let longitude: Double
}

class CountryService {
    
    private let api = APIService()
    
    // Carica la lista completa dei paesi
    func getAllCountries(token: String? = nil) async throws -> [CountryResponse] {
        return try await api.get(endpoint: "/countries", token: token)
    }
    
    // Carica i dettagli di un singolo paese
    func getCountry(by code: String, token: String? = nil) async throws -> CountryResponse {
        return try await api.get(endpoint: "/countries/\(code)", token: token)
    }
}
