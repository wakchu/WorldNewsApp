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
            let result = try await countryService.getAllCountries()
            self.countries = result
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
