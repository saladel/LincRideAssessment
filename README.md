## Table of contents

- [Task](#Task)
- [Task Overview](#Task-Overview)
- [Task Requirements](#Task-Requirements)
- [Demo](#Demo)
- [Architecture and Tools Used](#Architecture-and-Tools-Used)
- [Running the application](#Running-the-application)
- [Limitations](#Limitations)

## Task
Build a Location-Based Points of Interest (POI) Finder App

## Task Overview
Develop a simple iOS application that displays points of interest (POIs) around a user’s current location using Apple Maps and the MapKit framework. 
The app should allow users to:
- View their current location on an Apple Map.
- Search for nearby places (e.g., restaurants, cafes, gas stations) using Apple’s MKLocalSearch API.
- Select a place to see more details (e.g., name, category, address).
- Save favorite locations for offline access using CoreData or Realm.

## Task Requirements
### Requirements & Expectations:
- #### UI & User Experience
  - Use UIKit or SwiftUI to create a clean, responsive UI.
  - The app should have at least two screens:
      - Main Map Screen: Displays the user’s location and nearby places.
      - Details Screen: Shows information about a selected place.
- #### Apple Maps & Location Services
  - Use MapKit to display the Apple Map.
  - Fetch and display the user’s current location using CoreLocation.
  - Implement proper location permissions handling (requesting, denying, or revoking access).
- #### Search & Display Nearby Places
  - Use MKLocalSearch to find nearby POIs based on a user-defined category (e.g.restaurants, gas stations, cafes).
  - Display results on the map using custom annotations.
  - Clicking on an annotation should show a preview of the place (e.g., name, address).
- #### Data Persistence (Offline Feature)
  - Implement CoreData or Realm to allow users to save favorite places for offline access.
  - Display saved places even when offline.
- #### Networking & API Handling
  - Use MKLocalSearchCompleter to provide autocomplete search suggestions.
  - Implement proper error handling (e.g., location not found, API limitations).

## Demo
https://github.com/user-attachments/assets/623d75d4-62b4-4f0c-b8d5-7918984e4c94

## Architecture and Tools Used
- The application is built using Swift and SwiftUI.
- I made use of MapKit as stated in the requirement.
- I made use of MKLocalSearch, CoreLocation, and MKLocalSearchCompleter as stated in the requirements.
- I amde use of CoreData for persistence.

## Running the application
You can run the application on iOS 17.0 or later, iPadOS 15.5 and macOS 12.4 or later. You must have Xcode 15 or later installed.
1. Click on the green button labeled `Code` then select `Open with Xcode`
2. Click `allow` when the prompt shows.
3. Click `clone` when the prompt shows.
4. Click `Trust and Open` when the prompt shows.
5. Choose the device you'd like to run the app on.
6. Press the play button!

## Limitations 
- Users with iOS 16 or earlier will not be able to use the application due to the requirements and expectations given as the MapKit framework is only available for iOS 17+ users.

## How you approached the problem
I approached the problem by going through each requirement & expectation listed and solving them accordingly.


#
Feel free to reach out to me on [Linkedin](https://bit.ly/AdewaleSanusi) or [Twitter](https://twitter.com/A_4_Ade) if you have any questions or feedback!

[🔝](#Table-of-contents)

<!-- You can read the [FAQ](https://#) if you have any questions. -->
