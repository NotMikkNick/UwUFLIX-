import SwiftUI
import AVKit

struct MoviePlayerView: View {
    var movie: Movie
    @State private var player: AVPlayer?

    var body: some View {
        VStack {
            if let firstVideo = movie.videos.first {
                VideoPlayer(player: player)
                    .onAppear {
                        player = AVPlayer(url: firstVideo)
                        player?.play()
                    }
            } else {
                Text("No video available")
                    .font(.headline)
            }
        }
    }
}


