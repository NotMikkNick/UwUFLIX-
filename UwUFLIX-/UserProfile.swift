import Foundation
import SwiftUI

struct Profile: Identifiable, Codable {
    var id = UUID()
    var name: String
    var imageData: Data? // Hier für das Bild

    // Füge einen Computed Property hinzu, um das Bild aus den Daten zu laden
    var image: Image? {
        guard let data = imageData else { return nil }
        return Image(uiImage: UIImage(data: data)!)
    }
}
