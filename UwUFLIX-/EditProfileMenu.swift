import SwiftUI
struct EditProfileMenu: View {
    var profile: Profile
    @Binding var profiles: [Profile]
    @Binding var showMenu: Bool
    @State private var profileName: String
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    init(profile: Profile, profiles: Binding<[Profile]>, showMenu: Binding<Bool>) {
        self.profile = profile
        _profiles = profiles
        _showMenu = showMenu
        _profileName = State(initialValue: profile.name)
        if let imageData = profile.imageData, let uiImage = UIImage(data: imageData) {
            _selectedImage = State(initialValue: uiImage)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter Profile Name", text: $profileName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Button("Choose Image") {
                    showImagePicker.toggle()
                }
            }

            HStack {
                Button("Cancel") {
                    showMenu = false
                }

                Button("Save Changes") {
                    if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
                        profiles[index].name = profileName
                        profiles[index].imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                        saveProfiles()
                    }
                    showMenu = false
                }
                .disabled(profileName.isEmpty)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }

    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "profiles")
        }
    }
}
