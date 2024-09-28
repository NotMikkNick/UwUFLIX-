import Foundation

struct Movie: Identifiable, Codable {
    var id = UUID()
    var title: String
    var poster: String // Dateipfad oder URL zum Posterbild
    var genres: [String]
    var description: String
}
