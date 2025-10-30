import SwiftUI
import Combine

@MainActor
class MapViewModel: ObservableObject {
    @Published var countries: [CountryResponse] = []
    @Published var selectedCountry: CountryResponse?
    
    private let countryService: CountryService
    
    init(countryService: CountryService = CountryService()) {
        self.countryService = countryService
    }
    
    // Carica tutti i paesi dal backend
    func loadCountries() async {
        do {
            // Removed call to countryService.getAllCountries() as it's not needed at app start
            // and was causing a 403 Forbidden error before authentication.
        } catch {
            print("Errore caricamento paesi: \(error)")
            self.countries = []
        }
    }
    
    // Seleziona un paese dalla mappa
    func selectCountry(_ country: CountryResponse) {
        self.selectedCountry = country
    }
}
