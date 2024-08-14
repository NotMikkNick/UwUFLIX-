import SwiftUI
struct DeleteProfileConfirmation: View {
    var profile: Profile
    @Binding var profiles: [Profile]
    @Binding var showConfirmation: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to delete \(profile.name)?")
                .foregroundColor(.white)
                .padding()

            HStack {
                Button("Cancel") {
                    showConfirmation = false
                }

                Button("Delete") {
                    profiles.removeAll { $0.id == profile.id }
                    saveProfiles()
                    showConfirmation = false
                }
                .foregroundColor(.red)
            }
        }
    }

    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "profiles")
        }
    }
}
