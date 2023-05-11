//
//  PostersListView.swift
//  MusicFestivalCreator
//
//  Created by Brandon Fenske on 4/14/23.
//
import Foundation
import SwiftUI
import CoreData

struct PostersListView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(entity: MyPoster.entity(), sortDescriptors: [], predicate: nil, animation: nil) private var posters: FetchedResults<MyPoster>
    @State private var selectedPosters: Set<MyPoster> = []
    @State private var isInSelectionMode = false
    @State private var showingAlert = false

    var body: some View {
        VStack {
            Text("Saved Posters")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .padding()

            List {
                ForEach(posters, id: \.self) { poster in
                    HStack {
                        if isInSelectionMode {
                            Image(systemName: selectedPosters.contains(poster) ? "checkmark.square" : "square")
                                .onTapGesture {
                                    togglePosterSelection(poster)
                                }
                        }
                        Text(poster.name ?? "Unknown")
                        Spacer()
                        if let imageData = poster.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage).resizable().frame(width: isInSelectionMode || !selectedPosters.contains(poster) ? 50 : 150, height: isInSelectionMode || !selectedPosters.contains(poster) ? 50 : 150)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isInSelectionMode {
                            togglePosterSelection(poster)
                        } else {
                            selectedPosters = [poster]
                        }
                    }
                }
            }

            HStack {
                Button(action: {
                    isInSelectionMode.toggle()
                    if !isInSelectionMode {
                        selectedPosters.removeAll()
                    }
                }) {
                    Text(isInSelectionMode ? "Cancel" : "Select")
                        .padding()
                        .foregroundColor(.white)
                        .background(isInSelectionMode ? Color.red : Color.blue)
                        .cornerRadius(8)
                }

                Spacer()

                Button(action: {
                    showingAlert = true
                    deleteSelectedPosters()
                }) {
                    Text("Remove Poster")
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
                }
        .padding(.horizontal)
    .disabled(selectedPosters.isEmpty)
        }
            .padding(.horizontal)
                }
            .background(Color(red: 255/255, green: 228/255, blue: 196/255))
    }

    private func togglePosterSelection(_ poster: MyPoster) {
        if selectedPosters.contains(poster) {
            selectedPosters.remove(poster)
        } else {
            selectedPosters.insert(poster)
        }
    }

    private func deleteSelectedPosters() {
        for poster in selectedPosters {
            managedObjectContext.delete(poster)
        }
        do {
            try managedObjectContext.save()
            selectedPosters.removeAll()
            isInSelectionMode = false
        } catch {
            print("Error deleting poster: \(error.localizedDescription)")
        }
    }
}
