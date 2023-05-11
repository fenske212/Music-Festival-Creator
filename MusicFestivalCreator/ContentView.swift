//  ContentView.swift
//  MusicFestivalCreator
//
//  Created by Brandon Fenske on 4/14/23.
//
import SwiftUI

import Foundation


struct Artist: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
    var price: Int = 150000
    let genre: String
    let cost: Int
}

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Music")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                    Text("Festival")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                    Text("Creator")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                }
                .padding()
                
                Spacer()
                
                NavigationLink(destination: VenueManagerView()) {
                    Text("Go to Venue Manager")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        //.font(.custom("Marker Felt", size: 20))
                }
                .padding(.bottom, 5)
                
                NavigationLink(destination: PostersListView()) {
                    Text("View Saved Posters")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        //.font(.custom("Marker Felt", size: 20))
                }
                .padding(.bottom, 20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 255/255, green: 228/255, blue: 196/255))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
