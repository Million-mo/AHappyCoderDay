import SwiftUI
import CoreData

@main
struct AHappyCoderDayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
    }
}