import SwiftUI
import MapKit
import CoreLocation

// MARK: - MapView (SwiftUI)
struct MapView: View {
    var body: some View {
        NavigationStack {
            VStack {
                AppHeaderView()
                // Embed the MapViewControllerRepresentable to display the MapKit map
                MapViewControllerRepresentable()
                    .edgesIgnoringSafeArea(.bottom) // Extend map to the bottom edge
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationBarHidden(true) // Hide the default navigation bar
        }
    }
}

// MARK: - MapViewControllerRepresentable (SwiftUI Wrapper for UIKit's MKMapView)
struct MapViewControllerRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        // Create and configure the MKMapView
        let mapView = MKMapView()
        mapView.delegate = context.coordinator // Set the coordinator as the delegate
        context.coordinator.mapView = mapView // Pass the map view to the coordinator
        context.coordinator.loadAndDisplayCountries() // Load and display countries immediately
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the map view if needed (e.g., when data changes)
        // For now, we load annotations once in the coordinator's makeUIView
    }

    func makeCoordinator() -> Coordinator {
        // Create the coordinator to handle MKMapViewDelegate methods
        Coordinator(self)
    }

    // MARK: - Coordinator (MKMapViewDelegate)
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewControllerRepresentable
        var mapView: MKMapView? // Reference to the MKMapView
        private let countryService = CountryService() // Initialize CountryService

        init(_ parent: MapViewControllerRepresentable) {
            self.parent = parent
            super.init()
        }

        /// Loads country data from the JSON file and adds annotations to the map.
        func loadAndDisplayCountries() {
            guard let mapView = mapView else { return } // Ensure mapView is available
            do {
                let countries = try countryService.loadCountriesGeoData()
                let annotations = countries.map { countryGeoData -> MKPointAnnotation in
                    let annotation = MKPointAnnotation()
                    annotation.title = countryGeoData.country
                    annotation.coordinate = countryGeoData.coordinate
                    return annotation
                }
                // Add all created annotations to the map
                mapView.addAnnotations(annotations)
            } catch {
                print("Error loading country data: \(error.localizedDescription)")
                // Handle error, e.g., show an alert to the user
            }
        }

        // MARK: MKMapViewDelegate Methods

        /// Called when an annotation is selected on the map.
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation, let countryName = annotation.title {
                print("Selected country: \(countryName ?? "Unknown")")
                // Optionally, show a callout for the annotation
                mapView.selectAnnotation(annotation, animated: true)
            }
        }

        /// Provides a custom view for each annotation.
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Use the default MKPinAnnotationView for now
            guard annotation is MKPointAnnotation else { return nil }

            let identifier = "CountryAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true // Enable callout to show title
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