import Foundation

struct CountryResponse: Decodable {
    let code: String
    let name: String
    let latitude: Double
    let longitude: Double
}

class CountryService {
    
    private let api = APIService()
    
    func getAllCountries(token: String? = nil) async throws -> [CountryResponse] {
        return try await api.get(endpoint: "/countries", token: token)
    }
    
    func getCountry(by code: String, token: String? = nil) async throws -> CountryResponse {
        return try await api.get(endpoint: "/countries/\(code)", token: token)
    }
    

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
