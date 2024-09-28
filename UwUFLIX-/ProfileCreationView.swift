import SwiftUI

struct ProfileCreationView: View {
    @EnvironmentObject var profileManager: ProfileManager  // Zugriff auf den ProfileManager
    @State private var profileName: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var isProfileCreated: Bool = false  // Flag, um zu zeigen, dass das Profil erstellt wurde

    var body: some View {
        VStack {
            Text("Profil erstellen")
                .font(.largeTitle)
                .padding()

            // Profilbild auswählen
            Button(action: {
                isImagePickerPresented.toggle()
            }) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 2))
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .overlay(Image(systemName: "plus").font(.largeTitle))
                }
            }
            .padding()

            // Eingabefeld für den Profilnamen
            TextField("Profilname", text: $profileName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Profil erstellen Button
            Button(action: {
                // Überprüfen, ob der Profilname nicht leer ist
                guard !profileName.isEmpty else { return }
                
                // Konvertiere das Bild in Data, wenn ein Bild ausgewählt wurde
                let imageData = selectedImage?.jpegData(compressionQuality: 1.0)
                
                // Erstelle das Profil
                let newProfile = Profile(name: profileName, image: imageData)
                profileManager.saveProfile(newProfile) // Speichere das Profil
                
                // Optional: Zeige eine Bestätigung oder wechsle zurück zur Profilübersicht
                isProfileCreated = true // Hier kannst du eine Bestätigung hinzufügen oder eine Navigation zur Profilübersicht
            }) {
                Text("Profil erstellen")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            .padding()
            .alert(isPresented: $isProfileCreated) {
                Alert(title: Text("Profil erstellt"),
                      message: Text("Das Profil \(profileName) wurde erfolgreich erstellt."),
                      dismissButton: .default(Text("OK")))
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .padding()
    }
}
