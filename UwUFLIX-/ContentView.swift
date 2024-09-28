import SwiftUI

struct ContentView: View {
    @EnvironmentObject var profileManager: ProfileManager

    var body: some View {
        NavigationView {
            VStack {
                if profileManager.isFirstLaunch {
                    ProfileCreationView()
                } else {
                    ProfileSelectionView()
                }
            }
        }
    }
}
