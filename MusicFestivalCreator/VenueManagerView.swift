//
//  VenueManagerView.swift
//  MusicFestivalCreator
//
//  Created by Brandon Fenske on 4/14/23.
//
import Foundation
import SwiftUI
import MapKit

struct Venue: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D

    static func ==(lhs: Venue, rhs: Venue) -> Bool {
        return lhs.id == rhs.id
    }
}

struct VenueManagerView: View {
    
    @State private var isPosterViewPresented = false
    @State private var searchText: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.50, longitude: -98.35),
        span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)
    )
    
    
    //preloaded locations before search
    @State private var venues: [Venue] = [
        Venue(name: "Coachella", coordinate: CLLocationCoordinate2D(latitude: 33.67997, longitude: -116.23751)),
        Venue(name: "Glastonbury Festival", coordinate: CLLocationCoordinate2D(latitude: 51.15181, longitude: -2.46211)),
        Venue(name: "Tomorrowland", coordinate: CLLocationCoordinate2D(latitude: 51.08801, longitude: 4.42066)),
        Venue(name: "Lollapalooza", coordinate: CLLocationCoordinate2D(latitude: 41.87200, longitude: -87.61897)),
        Venue(name: "Rock in Rio", coordinate: CLLocationCoordinate2D(latitude: -22.96916, longitude: -43.24098)),
        Venue(name: "Roskilde Festival", coordinate: CLLocationCoordinate2D(latitude: 55.61800, longitude: 12.08149)),
        Venue(name: "Sziget Festival", coordinate: CLLocationCoordinate2D(latitude: 47.52863, longitude: 19.07405)),
        Venue(name: "Ultra Music Festival", coordinate: CLLocationCoordinate2D(latitude: 25.78897, longitude: -80.18801)),
        Venue(name: "Electric Daisy Carnival", coordinate: CLLocationCoordinate2D(latitude: 36.16994, longitude: -115.13983)),
        Venue(name: "Reading Festival", coordinate: CLLocationCoordinate2D(latitude: 51.45625, longitude: -0.96500)),
        Venue(name: "Leeds Festival", coordinate: CLLocationCoordinate2D(latitude: 53.87623, longitude: -1.39901)),
        Venue(name: "Bonnaroo Music and Arts Festival", coordinate: CLLocationCoordinate2D(latitude: 35.47202, longitude: -86.04608)),
        Venue(name: "Primavera Sound", coordinate: CLLocationCoordinate2D(latitude: 41.38506, longitude: 2.17340)),
        Venue(name: "Austin City Limits Music Festival", coordinate: CLLocationCoordinate2D(latitude: 30.26498, longitude: -97.74744)),
        Venue(name: "Burning Man", coordinate: CLLocationCoordinate2D(latitude: 40.78693, longitude: -119.20560)),
        Venue(name: "Fuji Rock Festival", coordinate: CLLocationCoordinate2D(latitude: 36.56709, longitude: 138.83148)),
        Venue(name: "Mawazine", coordinate: CLLocationCoordinate2D(latitude: 34.02798, longitude: -6.83235)),
        Venue(name: "New Orleans Jazz & Heritage Festival", coordinate: CLLocationCoordinate2D(latitude: 29.95107, longitude: -90.07153)),
        Venue(name: "Summerfest", coordinate: CLLocationCoordinate2D(latitude: 43.02863, longitude: -87.89802)),
        Venue(name: "Exit Festival", coordinate: CLLocationCoordinate2D(latitude: 45.24612, longitude: 19.84655)),
        Venue(name: "The Great Escape", coordinate: CLLocationCoordinate2D(latitude: 50.82146, longitude: -0.13622)),
        Venue(name: "Eurockéennes", coordinate: CLLocationCoordinate2D(latitude: 47.65781, longitude: 6.86590)),
        Venue(name: "Pinkpop Festival", coordinate: CLLocationCoordinate2D(latitude: 50.90976, longitude: 5.96853)),
        Venue(name: "Osheaga", coordinate: CLLocationCoordinate2D(latitude: 45.52023, longitude: -73.60687)),

        ]
    
    @State private var selectedVenue: Venue? = nil
    @State private var isContinueActive: Bool = false
    @State private var isTransitioningToArtistsListView: Bool = false
    
    var body: some View {
        VStack {
            Text("Select a Venue")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding()
            
            HStack {
                TextField("Search City for Venues", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    updateRegion()
                }) {
                    Text("Search")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
            }
            
            ZStack {
                Map(coordinateRegion: $region, annotationItems: venues) { venue in
                    MapAnnotation(coordinate: venue.coordinate) {
                        Button(action: {
                            selectedVenue = venue
                            isContinueActive = true
                        }) {
                            VStack {
                                Image(systemName: "mappin")
                                    .foregroundColor(selectedVenue == venue ? .red : .blue)
                                Text(venue.name)
                                    .foregroundColor(selectedVenue == venue ? .red : .blue)
                                    .bold()
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            zoomIn()
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                                .padding(.trailing, 4)
                        }
                        
                        Button(action: {
                            zoomOut()
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                                .padding(.leading, 4)
                        }
                    }
                }
                .padding()
                
                if !isContinueActive {
                    EmptyView().allowsHitTesting(false)
                }
            }
            
            Button(action: {
                if isContinueActive {
                    withAnimation {
                        isTransitioningToArtistsListView = true
                    }
                }
            }) {
                Text("Continue")
                    .foregroundColor(isContinueActive ? .white : .gray)
                    .padding()
                    .background(isContinueActive ? Color.blue : Color.gray.opacity(0.5))
                    .cornerRadius(10)
                    .disabled(!isContinueActive)
            }
            .padding()
        }

            .background(Color(red: 255/255, green: 228/255, blue: 196/255))

            .background(
                NavigationLink(destination: ArtistsListView(selectedVenue: selectedVenue), isActive: $isTransitioningToArtistsListView) {
                    EmptyView()
                }
            )
    }
    
    private func updateRegion() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { (placemarks, error) in
            guard let placemark = placemarks?.first,
                  let location = placemark.location else { return }
            region.center = location.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            searchVenues(in: region)
        }
    }
    
    private func searchVenues(in region: MKCoordinateRegion) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "music venue"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            venues = response.mapItems.map { item -> Venue in
                Venue(name: item.name ?? "Unknown", coordinate: item.placemark.coordinate)
            }
        }
    }
    
    private func zoomIn() {
        let newLatitudeDelta = max(region.span.latitudeDelta * 0.5, 0.005)
        let newLongitudeDelta = max(region.span.longitudeDelta * 0.5, 0.005)
        region.span = MKCoordinateSpan(latitudeDelta: newLatitudeDelta, longitudeDelta: newLongitudeDelta)
    }
    
    private func zoomOut() {
        let newLatitudeDelta = min(region.span.latitudeDelta * 2, 180)
        let newLongitudeDelta = min(region.span.longitudeDelta * 2, 180)
        region.span = MKCoordinateSpan(latitudeDelta: newLatitudeDelta, longitudeDelta: newLongitudeDelta)
    }
}
