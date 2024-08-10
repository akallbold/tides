import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @ObservedObject private var tideService = TideService.shared
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if let tideData = tideService.tideData {
                Text("Current Tide: \(String(describing: tideData.currentHeight?.height ?? 0))")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("Fetching tide data...")
            }
        }
        .onAppear {
            LocationManager()
        }
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                print("New location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                TideService.shared.fetchTideData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { _, _, error in
                    if let error = error {
                        self.errorMessage = error
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}
