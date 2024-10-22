import SwiftUI
import AVKit
import PhotosUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var profiles: [Profile] = []
    @State private var showAddProfileMenu = false
    @State private var showProfileSelection = false
    @State private var selectedProfile: Profile? = nil
    @State private var showEditProfileMenu = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if showProfileSelection {
                VStack {
                    Spacer()

                    VStack(spacing: 40) {
                        ForEach(profiles) { profile in
                            HStack {
                                if let imageData = profile.imageData, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(15)
                                }

                                Text(profile.name)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding(.leading, 16)

                                Spacer()

                                Button(action: {
                                    selectedProfile = profile
                                    showDeleteConfirmation.toggle()
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding()
                                }

                                Button(action: {
                                    selectedProfile = profile
                                    showEditProfileMenu.toggle()
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.yellow)
                                        .padding()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                        }
                    }

                    Spacer()

                    Button(action: { showAddProfileMenu.toggle() }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 30)

                    Button("Edit Profiles") {
                        // Action for editing profiles
                    }
                    .buttonStyle(ProfileButtonStyle(color: .gray))
                    .padding(.bottom, 50)
                }
            } else {
                IntroVideoView(showProfileSelection: $showProfileSelection)
                    .edgesIgnoringSafeArea(.all)
            }

            if showAddProfileMenu {
                AddProfileMenu(profiles: $profiles, showMenu: $showAddProfileMenu)
                    .transition(.move(edge: .bottom))
            }

            if showEditProfileMenu, let profile = selectedProfile {
                EditProfileMenu(profile: profile, profiles: $profiles, showMenu: $showEditProfileMenu)
                    .transition(.move(edge: .bottom))
            }

            if showDeleteConfirmation, let profile = selectedProfile {
                DeleteProfileConfirmation(profile: profile, profiles: $profiles, showConfirmation: $showDeleteConfirmation)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            loadProfiles()
        }
        .animation(.easeInOut)
    }

    func loadProfiles() {
        if let data = UserDefaults.standard.data(forKey: "profiles") {
            if let decodedProfiles = try? JSONDecoder().decode([Profile].self, from: data) {
                profiles = decodedProfiles
            }
        }
    }

    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "profiles")
        }
    }
}

struct IntroVideoView: View {
    @Binding var showProfileSelection: Bool
    private var player: AVPlayer

    init(showProfileSelection: Binding<Bool>) {
        _showProfileSelection = showProfileSelection
        let videoURL = Bundle.main.url(forResource: "intro", withExtension: "mp4")!
        player = AVPlayer(url: videoURL)
    }

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem,
                    queue: .main) { _ in
                        showProfileSelection = true
                    }
            }
            .disabled(true)
    }
}

struct AddProfileMenu: View {
    @Binding var profiles: [Profile]
    @Binding var showMenu: Bool
    @State private var newProfileName = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var selectedImageData: Data? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showingImagePicker = false

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Spacer()

                if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .onTapGesture {
                            showingImagePicker = true
                        }
                } else {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 180, height: 180)
                        .cornerRadius(20)
                        .padding(.bottom, 40)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }

                TextField("Enter Profile Name", text: $newProfileName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .placeholder(when: newProfileName.isEmpty) {
                        Text("Enter Profile Name").foregroundColor(.gray)
                    }

                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .placeholder(when: password.isEmpty) {
                                Text("Password").foregroundColor(.gray)
                            }
                    } else {
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .placeholder(when: password.isEmpty) {
                                Text("Password").foregroundColor(.gray)
                            }
                    }

                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Text(isPasswordVisible ? "HIDE" : "SHOW")
                    }
                    .foregroundColor(.gray)
                    .padding(.trailing, 20)
                }

                Button("Create Profile") {
                    if !newProfileName.isEmpty {
                        profiles.append(Profile(name: newProfileName, imageData: selectedImageData, password: password))
                        saveProfiles()
                        newProfileName = ""
                        password = ""
                        selectedImageData = nil
                        showMenu = false
                    }
                }
                .buttonStyle(ProfileButtonStyle(color: .blue))
                .padding(.top, 20)

                Spacer()
            }
            .padding()
            .background(Color.black)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingImagePicker) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {
                Text("Select a Photo")
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let newItem = newItem {
                        do {
                            if let data = try await newItem.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        } catch {
                            print("Error loading image data: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "profiles")
        }
    }
}

struct EditProfileMenu: View {
    @State private var profile: Profile
    @Binding var profiles: [Profile]
    @Binding var showMenu: Bool
    @State private var newProfileName: String
    @State private var selectedImageData: Data? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showingImagePicker = false

    init(profile: Profile, profiles: Binding<[Profile]>, showMenu: Binding<Bool>) {
        _profile = State(initialValue: profile)
        _profiles = profiles
        _showMenu = showMenu
        _newProfileName = State(initialValue: profile.name)
        _selectedImageData = State(initialValue: profile.imageData)
    }

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Spacer()

                if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .onTapGesture {
                            showingImagePicker = true
                        }
                } else {
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 180, height: 180)
                        .cornerRadius(20)
                        .padding(.bottom, 40)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }

                TextField("Enter Profile Name", text: $newProfileName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .placeholder(when: newProfileName.isEmpty) {
                        Text("Enter Profile Name").foregroundColor(.gray)
                    }

                Button("Save Changes") {
                    if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
                        profiles[index].name = newProfileName
                        profiles[index].imageData = selectedImageData
                        saveProfiles()
                        showMenu = false
                    }
                }
                .buttonStyle(ProfileButtonStyle(color: .blue))
                .padding(.top, 20)

                Spacer()
            }
            .padding()
            .background(Color.black)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingImagePicker) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {
                Text("Select a Photo")
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let newItem = newItem {
                        do {
                            if let data = try await newItem.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        } catch {
                            print("Error loading image data: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "profiles")
        }
    }
}

struct DeleteProfileConfirmation: View {
    var profile: Profile
    @Binding var profiles: [Profile]
    @Binding var showConfirmation: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to delete this profile?")
                .foregroundColor(.white)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            HStack {
                Button("Cancel") {
                    showConfirmation = false
                }
                .buttonStyle(ProfileButtonStyle(color: .gray))
                .padding(.horizontal, 20)

                Button("Delete") {
                    profiles.removeAll { $0.id == profile.id }
                    saveProfiles()
                    showConfirmation = false
                }
                .buttonStyle(ProfileButtonStyle(color: .red))
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "profiles")
        }
    }
}

struct Profile: Identifiable, Codable {
    var id = UUID()
    var name: String
    var imageData: Data?
    var password: String?
}

struct ProfileButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .cornerRadius(10)
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
