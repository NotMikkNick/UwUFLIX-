import SwiftUI

struct MovieMenuView: View {
    @EnvironmentObject var movieManager: MovieManager // MovieManager aus der Umgebung abrufen

    var body: some View {
        NavigationView {
            VStack {
                Text("Filme")
                    .font(.largeTitle)
                    .padding()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(movieManager.movies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                VStack {
                                    Image(movie.poster)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 200)
                                        .cornerRadius(10)

                                    Text(movie.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .onAppear {
                movieManager.loadMovies() // Filme beim Erscheinen der Ansicht laden
            }
        }
    }
}
