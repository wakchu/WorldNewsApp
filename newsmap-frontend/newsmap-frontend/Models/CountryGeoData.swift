
import Foundation
import CoreLocation

struct CountryGeoData: Codable, Identifiable, Hashable {
    let id = UUID()
    let country: String
    let alpha2: String
    let alpha3: String
    let numeric: Int
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case country
        case alpha2
        case alpha3
        case numeric
        case latitude
        case longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// Struct per decodificare la sovrastruttura del json
struct CountryGeoDataList: Codable {
    let refCountryCodes: [CountryGeoData]

    enum CodingKeys: String, CodingKey {
        case refCountryCodes = "ref_country_codes"
    }
}

