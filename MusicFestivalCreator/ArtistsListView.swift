//
//  ArtistsListView.swift
//  MusicFestivalCreator
//
//  Created by Brandon Fenske on 4/14/23.
//
import SwiftUI
import Combine

struct TopArtistsResponse: Codable {
    let artists: Artists
}

struct Artists: Codable {
    let artist: [ArtistResponse]
}

struct ArtistResponse: Codable {
    let name: String
}

struct ArtistsListView: View {
    @State private var artists: [Artist] = []
    @State private var selectedArtists: [Artist] = []
    @State private var budget: Int = 1500000
    @State private var isTransitioningToPosterView: Bool = false
    let selectedVenue: Venue?
    
    private let apiKey = "699c5f357c871332e0540309d4e7daab"
    private let baseURL = "https://ws.audioscrobbler.com/2.0/"
    
    var body: some View {
        VStack {
            if artists.isEmpty {
                Text("Loading artists...")
            } else {
                List(artists.indices, id: \.self) { index in
                    HStack {
                        Text(artists[index].name)
                            .font(.headline)
                        Spacer()
                        Text("$\(artists[index].price)")
                            .foregroundColor(.secondary)
                        Button(action: {
                            selectArtist(index)
                        }) {
                            Text(artists[index].isSelected ? "Deselect" : "Select")
                                .foregroundColor(artists[index].isSelected ? .red : .blue)
                        }
                    }
                }
            }
            
            HStack {
                Text("Choose your artists!")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding()
                Spacer()
                Text("Budget: $\(budget)")
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            Button(action: {
                isTransitioningToPosterView = true
            }) {
                Text("Select Artists")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(selectedArtists.isEmpty)
        }
        .onAppear {
            loadArtists()
        }
        .background(Color(red: 255/255, green: 228/255, blue: 196/255))
        .background(
            NavigationLink(destination: PosterView(artists: selectedArtists, venue: selectedVenue), isActive: $isTransitioningToPosterView) {
                    EmptyView()
                }
        )
    }
    private func loadArtists() {
        fetchTopArtists { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let artistResponses):
                    self.artists = artistResponses.map { Artist(name: $0.name, genre: "Unknown", cost: 100000) }
                case .failure(let error):
                    print("Error fetching artists: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchTopArtists(completion: @escaping (Result<[ArtistResponse], Error>) -> Void) {
        let queryItems = [
            URLQueryItem(name: "method", value: "chart.gettopartists"),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "format", value: "json")
        ]
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = queryItems
        
        guard let url = components.url else {
            fatalError("Invalid URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(TopArtistsResponse.self, from: data)
                completion(.success(decodedData.artists.artist))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    private func selectArtist(_ artistIndex: Int) {
        if artists[artistIndex].isSelected {
            artists[artistIndex].isSelected = false
            selectedArtists.removeAll(where: { $0.id == artists[artistIndex].id })
            budget += artists[artistIndex].price
        } else {
            if budget - artists[artistIndex].price >= 0 {
                artists[artistIndex].isSelected = true
                selectedArtists.append(artists[artistIndex])
                budget -= artists[artistIndex].price
            }
        }
    }
}
