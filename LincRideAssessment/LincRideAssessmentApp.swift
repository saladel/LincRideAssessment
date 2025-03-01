//
//  LincRideAssessmentApp.swift
//  LincRideAssessment
//
//  Created by Adewale Sanusi on 28/02/2025.
//

import SwiftUI

@main
struct LincRideAssessmentApp: App {
    
    @StateObject private var placesManager = PlacesManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placesManager)
        }
    }
}
