//
//  PosterView.swift
//  MusicFestivalCreator
//
//  Created by Brandon Fenske on 4/14/23.
//
import Foundation
import SwiftUI
import CoreData

struct PosterView: View {
    let artists: [Artist]
    @State private var posterName: String = ""
    @State private var posterImage: UIImage?
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    let venue: Venue?
    
    var body: some View {
        VStack {
            if let posterImage = posterImage {
                Image(uiImage: posterImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("Poster Preview")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
            }
            
            TextField("Poster Name", text: $posterName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            Button(action: savePoster) {
                Text("Save Poster")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .background(Color(red: 255/255, green: 228/255, blue: 196/255))
        .onAppear {
            createPosterImage()
        }
    }
    
    private func createPosterImage() {
        let imageSize = CGSize(width: 600, height: 800)
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        let image = renderer.image { context in
            // Set the background color
            UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1).setFill()
            context.fill(CGRect(origin: .zero, size: imageSize))

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attributes: [NSAttributedString.Key: Any] = [            .font: UIFont.systemFont(ofSize: 40, weight: .bold),            .foregroundColor: UIColor.white,            .paragraphStyle: paragraphStyle        ]
            let venueAttributes: [NSAttributedString.Key: Any] = [            .font: UIFont.systemFont(ofSize: 60, weight: .bold),            .foregroundColor: UIColor.white,            .paragraphStyle: paragraphStyle        ]

            if let venue = venue {
                let textRect = CGRect(x: 0, y: 20, width: imageSize.width, height: CGFloat.greatestFiniteMagnitude)
                let textBounds = venue.name.boundingRect(with: textRect.size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: venueAttributes, context: nil)
                let adjustedRect = CGRect(x: textRect.origin.x, y: textRect.origin.y, width: textRect.width, height: textBounds.height)
                venue.name.draw(in: adjustedRect, withAttributes: venueAttributes)
            }

            let rows = [1, 3, 3, 3]
            var currentArtistIndex = 0
            for (rowIndex, rowCount) in rows.enumerated() {
                for columnIndex in 0..<rowCount {
                    if currentArtistIndex < artists.count {
                        let artist = artists[currentArtistIndex]
                        let xOffset = imageSize.width / CGFloat(rowCount + 1)
                        let yOffset = imageSize.height / CGFloat(rows.count + 1) - 50 // Adjust the y-offset to reduce spacing between venue name and artist names
                        let textRect = CGRect(x: xOffset * CGFloat(columnIndex + 1) - xOffset / 2, y: yOffset * CGFloat(rowIndex + 1) + 140, width: xOffset, height: yOffset)
                        artist.name.draw(in: textRect, withAttributes: attributes)
                        currentArtistIndex += 1
                    }
                }
            }
        }

        posterImage = image
    }

    
    private func savePoster() {
        guard let posterImage = posterImage, let imageData = posterImage.jpegData(compressionQuality: 1.0) else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: "MyPoster", in: viewContext) else {
            print("Failed to find MyPoster entity description.")
            return
        }
        let newPoster = MyPoster(entity: entity, insertInto: viewContext)

        newPoster.name = posterName
        newPoster.imageData = imageData
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving poster: \(error.localizedDescription)")
        }
    }
}
