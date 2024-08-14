import Foundation

struct Profile: Identifiable, Codable {
    var id = UUID()
    var name: String
    var imageData: Data?
}
