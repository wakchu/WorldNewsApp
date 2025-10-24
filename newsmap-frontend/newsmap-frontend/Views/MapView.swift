import SwiftUI
import MapKit
import CoreLocation

// MARK: - MapView (SwiftUI)
struct MapView: View {
    @State private var selectedCountry: CountryGeoData? = nil

    var body: some View {
        NavigationStack {
            VStack {
                AppHeaderView()
                ZStack {
                    MapViewControllerRepresentable(selectedCountry: $selectedCountry)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    if let selectedCountry = selectedCountry {
                        NavigationLink(destination: NewsListView(countryName: selectedCountry.country, isoCode: selectedCountry.alpha3), isActive: .constant(true)) {
                            EmptyView()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
    }
}

// MARK: - MapViewControllerRepresentable (SwiftUI Wrapper for UIKit's MKMapView)
struct MapViewControllerRepresentable: UIViewRepresentable {
    @Binding var selectedCountry: CountryGeoData?

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
                parent.selectedCountry = country
            }
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

// MARK: - MapView_Previews
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}