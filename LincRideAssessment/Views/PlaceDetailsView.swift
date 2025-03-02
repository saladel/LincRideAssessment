//
//  PlaceDetailsView.swift
//  LincRideAssessment
//
//  Created by Adewale Sanusi on 28/02/2025.
//

import SwiftUI
import MapKit

struct PlaceDetailsView: View {
    @Binding var selectedPlace: MKMapItem?
    @Binding var show: Bool
    @Binding var getDirectons: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    
    @EnvironmentObject var placesManager: PlacesManager
    var isSaved: Bool {
        guard let place = selectedPlace else { return false }
        return placesManager.placeExists(place)
    }
    
    var body: some View {
        VStack {
            // header
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(selectedPlace?.placemark.name ?? "")
                        .font(.title2)
                        .lineLimit(2)
                        .fontWeight(.semibold)
                    
                    Text(selectedPlace?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                    
                    // Add category if available
                    if let category = selectedPlace?.pointOfInterestCategory?.rawValue {
                        Text(category)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                Button {
                    show.toggle()
                    selectedPlace = nil
                } label: {
                    Image(systemName: "xmark.app")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            .padding(.top)
            
            if let scene = lookAroundScene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.vertical)
            } else {
                ContentUnavailableView(
                    "No preview available for this place",
                    systemImage: "eye.slash"
                )
            }
            
            // buttons
            HStack {
                // map
                Button {
                    if let selectedPlace {
                        selectedPlace.openInMaps()
                    }
                } label: {
                    Text("Open In Maps")
                        .font(.headline)
                        .foregroundStyle(.green)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.purple, lineWidth: 1)
                        }
                }
                
                Spacer()
                
                // saves the place
                Button {
                    if let place = selectedPlace {
                        if isSaved {
                            // Finds the saved place and remove it
                            if let savedPlace = placesManager.savedPlaces.first(where: {
                                $0.name == place.placemark.name &&
                                $0.latitude == place.placemark.coordinate.latitude &&
                                $0.longitude == place.placemark.coordinate.longitude
                            }), let id = savedPlace.id {
                                placesManager.removeFavoritePlace(id)
                            }
                        } else {
                            // Saves the place
                            placesManager.saveFavoritePlace(place)
                        }
                    }
                } label: {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 17)
                        .font(.headline)
                        .foregroundStyle(.red)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.purple, lineWidth: 1)
                        }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: selectedPlace) { oldValue, newValue in
            fetchLookAroundPreview()
        }
    }
}

extension PlaceDetailsView {
    func fetchLookAroundPreview() {
        if let selectedPlace {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: selectedPlace)
                lookAroundScene = try? await request.scene
            }
        }
    }
}

#Preview {
    PlaceDetailsView(
        selectedPlace: .constant(nil),
        show: .constant(true),
        getDirectons: .constant(true)
    )
    .environmentObject(PlacesManager())
}
