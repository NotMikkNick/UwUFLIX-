import SwiftUI
import PhotosUI
import AVKit

// Define the Profile model
struct Profile: Identifiable, Codable {
    var id = UUID()
    var name: String
    var imageData: Data?
}

// Define the Movie model
struct Movie: Identifiable {
    var id: UUID
    var title: String
    var posterImage: String
}

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
    @State private var showFilmMenu = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if let profile = selectedProfile, showFilmMenu {
                FilmMenuView()  // Erstellen einer Instanz von FilmMenuView
            } else if showProfileSelection {
                VStack {
                    Spacer()

                    VStack(spacing: 20) {
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
                            .onTapGesture {
                                selectedProfile = profile
                                showFilmMenu = true
                            }
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
}

// ProfileButtonStyle
struct ProfileButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

// IntroVideoView
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

// AddProfileMenu
struct AddProfileMenu: View {
    @Binding var profiles: [Profile]
    @Binding var showMenu: Bool
    @State private var newProfileName = ""
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
                        .fill(Color.blue)
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

                Button("Create Profile") {
                    if !newProfileName.isEmpty {
                        profiles.append(Profile(name: newProfileName, imageData: selectedImageData))
                        saveProfiles()
                        newProfileName = ""
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

// EditProfileMenu
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
                        .fill(Color.blue)
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

// DeleteProfileConfirmation
struct DeleteProfileConfirmation: View {
    var profile: Profile
    @Binding var profiles: [Profile]
    @Binding var showConfirmation: Bool

    var body: some View {
        VStack {
            Text("Are you sure you want to delete this profile?")
                .foregroundColor(.white)
                .padding()

            HStack {
                Button("Cancel") {
                    showConfirmation = false
                }
                .buttonStyle(ProfileButtonStyle(color: .gray))

                Button("Delete") {
                    if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
                        profiles.remove(at: index)
                        saveProfiles()
                        showConfirmation = false
                    }
                }
                .buttonStyle(ProfileButtonStyle(color: .red))
            }
            .padding()
        }
        .padding()
        .background(Color.black)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }

    func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "profiles")
        }
    }
}

import SwiftUI
import AVKit

// FilmMenuView mit verbessertem Design
struct FilmMenuView: View {
    @State private var movies: [Movie] = []

    var body: some View {
        VStack {
            Text("Available Movies")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(movies) { movie in
                        VStack {
                            if let image = UIImage(contentsOfFile: movie.posterImage) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 225)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                            } else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 150, height: 225)
                                    .cornerRadius(10)
                                    .overlay(
                                        Text("No Image")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                    )
                                    .shadow(radius: 10)
                            }

                            Text(movie.title)
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.top, 5)
                        }
                    }
                }
                .padding()
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(20)
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            loadMovies()
        }
    }

    func loadMovies() {
        let fileManager = FileManager.default
        guard let moviesDirectory = Bundle.main.resourcePath.map({ $0 + "/Movies" }) else {
            print("Movies directory not found")
            return
        }

        print("Movies directory path: \(moviesDirectory)")
        
        do {
            let movieDirectories = try fileManager.contentsOfDirectory(atPath: moviesDirectory)
            for directory in movieDirectories {
                let moviePath = moviesDirectory + "/\(directory)"
                let posterImagePath = try fileManager.contentsOfDirectory(atPath: moviePath).first { $0.hasSuffix(".jpg") }

                if let posterImagePath = posterImagePath {
                    let posterFullPath = moviePath + "/\(posterImagePath)"
                    if fileManager.fileExists(atPath: posterFullPath) {
                        let movie = Movie(id: UUID(), title: directory, posterImage: posterFullPath)
                        movies.append(movie)
                        print("Loaded movie: \(movie.title) with poster: \(movie.posterImage)")
                    } else {
                        print("Poster image file does not exist at path: \(posterFullPath)")
                    }
                } else {
                    print("No .jpg file found in directory: \(moviePath)")
                }
            }

            if movies.isEmpty {
                print("No movies were found in the directory.")
            }

        } catch {
            print("Error loading movies: \(error.localizedDescription)")
        }
    }
}
