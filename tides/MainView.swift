////
////  MainView.swift
////  tides
////
////  Created by Anna Kallenborn-Bolden on 7/29/24.
////
//
//import Foundation
//import SwiftUI
//import CoreLocation
//
//struct MainView: View {
//    @StateObject private var locationManager = LocationManager()
//    @State private var tideData: TideData?
//
//    var body: some View {
//        VStack {
//            if let tideData = tideData {
//                Text("Current Tide: \(String(describing: tideData.currentHeight) )")
//          
//            } else {
//                Text("Fetching tide data...")
//            }
//        }
//        .onAppear {
//            fetchTideData()
//        }
//    }
//
//    private func fetchTideData() {
//        guard let location = locationManager.location else { return }
//
//        TideService.shared.fetchTideData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { tideData in
//            self.tideData = tideData
//        }
//    }
//}
