//
//  MapView.swift
//  LincRideAssessment
//
//  Created by Adewale Sanusi on 28/02/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchCompleter = SearchCompleter()
    @EnvironmentObject var placesManager: PlacesManager
    
    @Namespace var mapScope
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion.userRegion)
    
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var isSearching = false
    
    @State private var selectPlaceOnMap: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectPlaceOnMap) {
            Annotation("My Location", coordinate: locationManager.lastLocation?.coordinate ?? .userLocation) {
                Image(systemName: "figure.wave")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.purple)
                    .background(
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.blue)
                            
                            Circle()
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.white)
                        }
                            .padding()
                    )
            }
            
            ForEach(results, id: \.self) { place in
                let placeMark = place.placemark
                Marker(
                    placeMark.name ?? "Unknown Place",
                    systemImage: "mappin.and.ellipse",
                    coordinate: placeMark.coordinate
                )
                .tint(.purple)
            }
        }
        .onChange(of: selectPlaceOnMap) { oldValue, newValue in
            showDetails = newValue != nil
        }
        .onChange(of: locationManager.lastLocation) { oldValue, newValue in
            if let location = newValue {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            }
        }
        .sheet(
            isPresented: $showDetails,
            content: {
                PlaceDetailsView(
                    selectedPlace: $selectPlaceOnMap,
                    show: $showDetails,
                    getDirectons: $getDirections
                )
                .presentationDetents([.height(370)])
                .presentationDragIndicator(.hidden)
                .presentationBackgroundInteraction(
                    .enabled(upThrough: .height(370))
                )
                .presentationCornerRadius(12)
            }
        )
        .overlay(alignment: .top) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search for a place...", text: $searchText)
                        .font(.subheadline)
                        .onSubmit {
                            Task {
                                await searchPlaces(searchText)
                                isSearching = false
                            }
                        }
                        .onChange(of: searchText) { oldValue, newValue in
                            if !newValue.isEmpty {
                                searchCompleter.search(query: newValue)
                                isSearching = true
                            } else {
                                searchCompleter.suggestions = []
                                isSearching = false
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                            searchCompleter.suggestions = []
                            isSearching = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.15), radius: 5)
                )
                .padding()
                
                // Autocomplete suggestions
                if isSearching && !searchCompleter.suggestions.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(searchCompleter.suggestions, id: \.self) { suggestion in
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.red)
                                    
                                    Text(suggestion.title)
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    searchText = suggestion.title
                                    Task {
                                        await searchPlaces(suggestion.title)
                                        isSearching = false
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.15), radius: 5)
                        )
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 200)
                }
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .alert(isPresented: Binding<Bool>(
            get: { locationManager.errorMessage != nil },
            set: { if !$0 { locationManager.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Location Error"),
                message: Text(locationManager.errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func searchPlaces(_ query: String) async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        if let location = locationManager.lastLocation {
            request.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        } else {
            request.region = .userRegion
        }
        
        do {
            let response = try await MKLocalSearch(request: request).start()
            results = response.mapItems
            
            if let firstItem = results.first {
                let annotations = results.map { $0.placemark.coordinate }
                
                if annotations.count == 1 {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: firstItem.placemark.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
                } else {
                    let region = MKCoordinateRegion(coordinates: annotations)
                    cameraPosition = .region(region)
                }
            }
        } catch {
            print("Error searching for places: \(error.localizedDescription)")
        }
    }
}

class SearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    private let completer = MKLocalSearchCompleter()
    @Published var suggestions: [MKLocalSearchCompletion] = []
    
    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.pointOfInterest, .address]
    }
    
    func search(query: String) {
        completer.queryFragment = query
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
}




#Preview {
    MapView()
}
