//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Jacob and Shalise on 5/10/22.
//

import Foundation
import LocalAuthentication
import MapKit
import SwiftUI

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33, longitude: -97), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
        
        @Published private(set) var locations: [Location]
        
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        @Published var authenticationError = "Unknown error"
        @Published var isShowingAuthenticationError = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
           locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }  
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success,
                    authenticationError in
                    Task {
                        @MainActor in
                    if success {
                                self.isUnlocked = true
                        
                    } else {
                            self.authenticationError = "There was a problem authenticating you; please try again."
                            self.isShowingAuthenticationError = true
                        }
                    }
                }
            } else {
                authenticationError = "Sorry, your device does not suport biometric authentication"
                isShowingAuthenticationError = true
            }
        }
    }
}
