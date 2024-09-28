import SwiftUI

@main
struct MyApp: App {
    @StateObject private var profileManager = ProfileManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(profileManager)
        }
    }
}
