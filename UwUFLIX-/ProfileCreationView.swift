import SwiftUI

struct ProfileCreationView: View {
    @EnvironmentObject var profileManager: ProfileManager
    @State private var newProfileName: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false

    var body: some View {
        VStack {
            Text("Tutorial: Neues Profil erstellen")
                .font(.largeTitle)
                .padding()

            TextField("Profilname", text: $newProfileName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                isImagePickerPresented = true
            }) {
                Text("Profilbild auswählen")
            }
            .padding()

            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }

            Button("Profil erstellen") {
                // Speichern des Bildes als Data
                let imageData = selectedImage?.pngData() // oder jpegData(compressionQuality:)
                let newProfile = Profile(name: newProfileName, imageData: imageData)
                profileManager.saveProfile(newProfile)
                newProfileName = "" // Eingabefeld zurücksetzen
                selectedImage = nil // Bild zurücksetzen
            }
            .padding()

            Spacer()
        }
        .padding()
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
    }
}
