import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    
    var body: some View {
        VStack {
            Text(movie.title)
                .font(.largeTitle)
                .padding()
            
            Image(movie.poster)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(10)
            
            Text(movie.description)
                .padding()
            
            Spacer()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
