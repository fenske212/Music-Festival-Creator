//
//  MusicFestivalCreatorApp.swift
//  MusicFestivalCreator
//
//  Created by Brandon Fenske on 4/14/23.
//

import SwiftUI

@main
struct MusicFestivalCreatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
