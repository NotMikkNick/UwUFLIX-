import SwiftUI

struct FilmListView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(0..<10) { index in
                    VStack {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 150, height: 225)
                        
                        Text("Film \(index + 1)")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
            }
        }
        .background(Color.black)
        .navigationTitle("Filme und Serien")
    }
}
