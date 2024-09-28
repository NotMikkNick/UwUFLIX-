import Foundation

class ProfileManager: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var isFirstLaunch: Bool = true

    private let profilesKey = "profiles"

    init() {
        loadProfiles()
    }

    func loadProfiles() {
        // Lade den Status des ersten Starts aus UserDefaults
        if let firstLaunch = UserDefaults.standard.value(forKey: "isFirstLaunch") as? Bool {
            isFirstLaunch = firstLaunch
        } else {
            isFirstLaunch = true // Erster Start, wenn der Schlüssel nicht existiert
        }

        // Lade die gespeicherten Profile
        if let data = UserDefaults.standard.data(forKey: profilesKey) {
            if let decodedProfiles = try? JSONDecoder().decode([Profile].self, from: data) {
                profiles = decodedProfiles
            }
        }
    }

    func saveProfile(_ profile: Profile) {
        profiles.append(profile)

        // Speichere die Profile in UserDefaults
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: profilesKey)
        }

        // Setze den Status des ersten Starts auf false
        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
        isFirstLaunch = false
    }
}
