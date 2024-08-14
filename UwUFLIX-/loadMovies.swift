import SwiftUI

func loadMovies() -> [Movie] {
    let fileManager = FileManager.default
    let moviesDirectory = URL(fileURLWithPath: "/Users/grisa/Documents/UwUFLIX-/Movies")

    do {
        let movieFolders = try fileManager.contentsOfDirectory(at: moviesDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        return movieFolders.compactMap { folderURL in
            guard folderURL.hasDirectoryPath else { return nil }
            
            let movieName = folderURL.lastPathComponent
            let posterURL = folderURL.appendingPathComponent("\(movieName)poster.jpg")
            let assetsURL = folderURL.appendingPathComponent("assets")
            
            let posterImage = UIImage(contentsOfFile: posterURL.path)
            let videoFiles = (try? fileManager.contentsOfDirectory(at: assetsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles))?.filter { $0.pathExtension == "mp4" }
            
            return Movie(title: movieName, poster: posterImage, videos: videoFiles ?? [])
        }
    } catch {   
        print("Failed to load movies: \(error.localizedDescription)")
        return []
    }
}
