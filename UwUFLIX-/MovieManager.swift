import Foundation

class MovieManager: ObservableObject {
    @Published var movies: [Movie] = []
    
    func loadMovies() {
        // Hier könntest du die Logik implementieren, um Filme aus deinem Dateisystem zu laden
        // Zum Beispiel: Durchsuchen des Ordners und Erstellen von Movie-Objekten
        
        // Beispiel-Daten
        movies = [
            Movie(title: "Film 1", poster: "path/to/poster1.jpg", genres: ["Action", "Drama"], description: "Eine spannende Handlung."),
            Movie(title: "Film 2", poster: "path/to/poster2.jpg", genres: ["Komödie"], description: "Eine lustige Geschichte.")
        ]
    }
}
