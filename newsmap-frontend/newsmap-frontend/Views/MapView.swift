import SwiftUI
import MapKit
import CoreLocation

// MARK: - MapView (SwiftUI)
struct MapView: View {
    @State private var selectedCountry: CountryGeoData? = nil
    @State private var showingNews: Bool = false
    @StateObject var newsViewModel = NewsViewModel()

    var body: some View {
        MapViewControllerRepresentable(selectedCountry: $selectedCountry, showingNews: $showingNews, newsViewModel: newsViewModel)
            .id("mapViewRepresentable") // Add a stable ID
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $showingNews) {
                NavigationStack {
                    if let country = selectedCountry {
                        NewsListView(newsViewModel: newsViewModel, countryCode: country.alpha2)
                    }
                }
            }
    }
}

struct MapViewControllerRepresentable: UIViewRepresentable {
    @Binding var selectedCountry: CountryGeoData?
    @Binding var showingNews: Bool
    var newsViewModel: NewsViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        context.coordinator.mapView = mapView
        context.coordinator.loadAndDisplayCountries()
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // MARK: - Coordinator (MKMapViewDelegate)
            class Coordinator: NSObject, MKMapViewDelegate {
                var parent: MapViewControllerRepresentable
                var mapView: MKMapView?
                private let countryService = CountryService()
                private let newsService = NewsService()
                private var countries: [CountryGeoData] = []
    
                init(_ parent: MapViewControllerRepresentable) {
                    self.parent = parent
                    super.init()
                }
    
                func loadAndDisplayCountries() {
                    guard let mapView = mapView else { return }
                    do {
                        countries = try countryService.loadCountriesGeoData()
                        let annotations = countries.map { countryGeoData -> MKPointAnnotation in
                            let annotation = MKPointAnnotation()
                            annotation.title = countryGeoData.country
                            annotation.coordinate = countryGeoData.coordinate
                            return annotation
                        }
                        mapView.addAnnotations(annotations)
                    } catch {
                        print("Error loading country data: \(error.localizedDescription)")
                    }
                }
    
                func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
                    if let annotation = view.annotation, let countryName = annotation.title, let country = countries.first(where: { $0.country == countryName }) {
                        // Deselect the annotation to ensure navigation re-triggers even if the same country is selected
                        mapView.deselectAnnotation(annotation, animated: false)
                        
                        Task {
                            do {
                                let token = KeychainHelper.standard.read(service: "auth", account: "jwt")
                                print("Token: \(token ?? "nil")")
                                print("Calling fetchNews for country \(country.alpha2)")
                                try await newsService.fetchNews(for: country.alpha2, token: token)
                                print("fetchNews call completed in MapView.")
                                await parent.newsViewModel.loadNews(for: country.alpha2, token: token)
                                parent.selectedCountry = country
                                print("selectedCountry: \(parent.selectedCountry?.country ?? "nil"), showingNews before update: \(parent.showingNews)")
                                parent.showingNews = true
                                print("showingNews after update: \(parent.showingNews)")
                            } catch {
                                print("Error in fetchNews: \(error.localizedDescription)")
                            }
                        }
                    }
                }
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            parent.selectedCountry = nil
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is MKPointAnnotation else { return nil }

            let identifier = "CountryAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
