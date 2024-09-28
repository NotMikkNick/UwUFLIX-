import Foundation
import SwiftUI

struct Profile: Identifiable, Codable { // Codable hinzufügen für die JSON-Codierung
    var id = UUID() // Eindeutige ID für das Profil
    var name: String
    var image: Data? // Verwende Data für das Bild, um es zu speichern
}
