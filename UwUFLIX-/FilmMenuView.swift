import SwiftUI

struct FilmMenuView: View {
    var body: some View {
        VStack {
            Text("For Everyone.")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 40)

            HStack {
                Button(action: {
                    // Action for Series
                }) {
                    Text("Series")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }

                Button(action: {
                    // Action for Films
                }) {
                    Text("Films")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }

                Menu("Categories") {
                    Button("Action", action: {})
                    Button("Comedy", action: {})
                    Button("Drama", action: {})
                    Button("Horror", action: {})
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
            }
            .padding(.top, 20)

            Spacer()

            // Add your film grid or list here

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
