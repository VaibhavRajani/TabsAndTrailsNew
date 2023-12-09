//
//  TabsAndTrailsApp.swift
//  TabsAndTrails
//
//  Created by Vaibhav Rajani on 12/9/23.
//

import SwiftUI

@main
struct T_TcloneApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
