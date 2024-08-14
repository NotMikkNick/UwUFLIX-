import SwiftUI
import AVKit

struct IntroVideoView: View {
    @Binding var showProfileSelection: Bool

    var body: some View {
        VideoPlayer(player: AVPlayer(url: URL(string: "https://www.example.com/your_video.mp4")!))
            .onTapGesture {
                showProfileSelection.toggle()
            }
    }
}
