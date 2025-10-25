
import Foundation
import CoreLocation

// MARK: - CountryGeoData
// Struct to decode individual country data from the JSON file.
struct CountryGeoData: Codable, Identifiable, Hashable {
    let id = UUID() // Conforming to Identifiable for use in ForEach or lists
    let country: String
    let alpha2: String
    let alpha3: String
    let numeric: Int
    let latitude: Double
    let longitude: Double

    // CodingKeys to map JSON keys to Swift properties, especially for 'country'
    enum CodingKeys: String, CodingKey {
        case country
        case alpha2
        case alpha3
        case numeric
        case latitude
        case longitude
    }
    
    // Computed property to return CLLocationCoordinate2D for MapKit
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - CountryGeoDataList
// Struct to decode the top-level structure of the JSON file.
struct CountryGeoDataList: Codable {
    let refCountryCodes: [CountryGeoData]

    enum CodingKeys: String, CodingKey {
        case refCountryCodes = "ref_country_codes"
    }
}
