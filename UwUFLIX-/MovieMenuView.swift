import SwiftUI
import AVKit

struct MovieMenuView: View {
    let movieDirectory = "/Users/grisa/Documents/UwUFLIX-/Movies"
    @State private var movies: [Movie] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("For Everyone.")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    Button("Series") {
                        // Handle Series Action
                    }
                    .buttonStyle(CategoryButtonStyle())
                    
                    Button("Films") {
                        // Handle Films Action
                    }
                    .buttonStyle(CategoryButtonStyle())
                    
                    Menu {
                        Button("Action") {}
                        Button("Comedy") {}
                        Button("Drama") {}
                        // Add more categories as needed
                    } label: {
                        Label("Categories", systemImage: "chevron.down")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 20)]) {
                    ForEach(movies) { movie in
                        VStack {
                            if let imageData = movie.posterImage, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 180)
                                    .cornerRadius(8)
                            }
                            Text(movie.name)
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .onTapGesture {
                            // Handle movie selection
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black)
        .onAppear {
            loadMovies()
        }
    }
    
    func loadMovies() {
        let fileManager = FileManager.default
        guard let movieFolders = try? fileManager.contentsOfDirectory(atPath: movieDirectory) else { return }
        
        for folder in movieFolders {
            let folderPath = "\(movieDirectory)/\(folder)"
            let posterPath = "\(folderPath)/\(folder)poster.jpg"
            let assetsPath = "\(folderPath)/assets"
            
            if let imageData = try? Data(contentsOf: URL(fileURLWithPath: posterPath)) {
                var videoFiles: [URL] = []
                
                if let assetFiles = try? fileManager.contentsOfDirectory(atPath: assetsPath) {
                    videoFiles = assetFiles.compactMap { fileName in
                        URL(fileURLWithPath: "\(assetsPath)/\(fileName)")
                    }
                }
                
                let movie = Movie(name: folder, posterImage: imageData, videoFiles: videoFiles)
                movies.append(movie)
            }
        }
    }
}

struct Movie: Identifiable {
    let id = UUID()
    let name: String
    let posterImage: Data?
    let videoFiles: [URL]
}

struct CategoryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .foregroundColor(.white)
    }
}
