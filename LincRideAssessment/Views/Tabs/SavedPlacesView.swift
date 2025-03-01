//
//  SavedPlacesView.swift
//  LincRideAssessment
//
//  Created by Adewale Sanusi on 28/02/2025.
//

import SwiftUI
import MapKit
import CoreData

struct SavedPlacesView: View {
    @EnvironmentObject var placesManager: PlacesManager
    @State private var searchText = ""
    @State private var selectedPlace: FavoritePlace?
    @State private var showOnMap = false
    
    var filteredPlaces: [FavoritePlace] {
        if searchText.isEmpty {
            return placesManager.savedPlaces
        } else {
            return placesManager.savedPlaces.filter {
                $0.name?.localizedCaseInsensitiveContains(searchText) == true ||
                $0.address?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if placesManager.savedPlaces.isEmpty {
                    ContentUnavailableView(
                        "No Saved Places",
                        systemImage: "mappin.slash",
                        description: Text("Your favorite places will appear here.")
                    )
                } else {
                    List {
                        ForEach(filteredPlaces) { place in
                            VStack(alignment: .leading) {
                                Text(place.name ?? "Unknown Place")
                                    .font(.headline)
                                
                                Text(place.address ?? "")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                if let category = place.category {
                                    Text(category)
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    if let id = place.id {
                                        placesManager.removeFavoritePlace(id)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    selectedPlace = place
                                    showOnMap = true
                                } label: {
                                    Label("View on Map", systemImage: "map")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Saved Places")
            .searchable(text: $searchText, prompt: "Search saved places")
            .navigationDestination(isPresented: $showOnMap) {
                if let place = selectedPlace {
                    SavedPlaceMapView(place: place)
                }
            }
        }
    }
}

class MockPlacesManager: ObservableObject {
    @Published var savedPlaces: [FavoritePlace] = []
    
    init(includeTestData: Bool = true) {
        if includeTestData {
            
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            
           
            let place1 = FavoritePlace(context: context)
            place1.id = UUID()
            place1.name = "Coffee Shop"
            place1.address = "123 Main St"
            place1.latitude = 37.7749
            place1.longitude = -122.4194
            place1.dateAdded = Date()
            place1.category = "cafe"
            
            let place2 = FavoritePlace(context: context)
            place2.id = UUID()
            place2.name = "Public Library"
            place2.address = "456 Oak Ave"
            place2.latitude = 37.7749
            place2.longitude = -122.4194
            place2.dateAdded = Date()
            place2.category = "library"
            
            savedPlaces = [place1, place2]
        }
    }
    
    func removeFavoritePlace(_ placeID: UUID) {
        savedPlaces.removeAll { $0.id == placeID }
    }
}

struct SavedPlaceMapView: View {
    let place: FavoritePlace
    
    var body: some View {
        Map {
            Marker(
                place.name ?? "Saved Place",
                coordinate: CLLocationCoordinate2D(
                    latitude: place.latitude,
                    longitude: place.longitude
                )
            )
            .tint(.purple)
        }
        .navigationTitle(place.name ?? "Saved Place")
    }
}

#Preview {
    SavedPlacesView()
        .environmentObject(MockPlacesManager())
}
