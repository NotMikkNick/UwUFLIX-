import SwiftUI

struct AddProfileMenu: View {
    @Binding var profiles: [Profile]
    @Binding var showMenu: Bool
    @State private var profileName: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false

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

                Button("Add Profile") {
                    let newProfile = Profile(name: profileName, imageData: selectedImage?.jpegData(compressionQuality: 0.8))
                    profiles.append(newProfile)
                    saveProfiles()
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
