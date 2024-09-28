import SwiftUI

struct ProfileDetailView: View {
    var profile: Profile

    var body: some View {
        VStack {
            Text("Profilname: \(profile.name)")
                .font(.largeTitle)
                .padding()

            // Hier kannst du weitere Informationen zum Profil hinzufügen

            Spacer()
        }
        .navigationTitle("Profil Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
