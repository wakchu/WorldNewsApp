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
    
    /// Loads country geographical data from a local JSON file within the app bundle.
    /// - Returns: An array of `CountryGeoData` objects.
    /// - Throws: `CountryServiceError` if the file cannot be found, data is invalid, or decoding fails.
    func loadCountriesGeoData() throws -> [CountryGeoData] {
        guard let url = Bundle.main.url(forResource: "country-codes-lat-long-alpha3", withExtension: "json") else {
            throw CountryServiceError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let countryList = try decoder.decode(CountryGeoDataList.self, from: data)
        return countryList.refCountryCodes
    }
}

// Custom error type for CountryService operations
enum CountryServiceError: Error, LocalizedError {
    case fileNotFound
    case decodingFailed(Error)
    case networkError(Error)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "The country data file could not be found in the app bundle."
        case .decodingFailed(let error):
            return "Failed to decode country data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
