import SwiftUI

struct Profile: Identifiable {
    let id = UUID()
    var name: String
    var imageData: Data?
}
