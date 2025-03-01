//
//  TabView.swift
//  LincRideAssessment
//
//  Created by Adewale Sanusi on 28/02/2025.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            SavedPlacesView()
                .tabItem {
                    Label("Saved Places", systemImage: "mappin.and.ellipse.circle.fill")
                }
        }
        .tint(.purple)
    }
}

#Preview {
    HomeTabView()
}
