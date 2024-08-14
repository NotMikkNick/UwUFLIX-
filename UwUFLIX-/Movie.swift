import SwiftUI

struct Movie: Identifiable {
    var id = UUID()
    var title: String
    var poster: UIImage?
    var videos: [URL]
}
