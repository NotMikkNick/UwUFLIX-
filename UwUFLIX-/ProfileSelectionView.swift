import SwiftUI

struct ProfileSelectionView: View {
    @EnvironmentObject var profileManager: ProfileManager
    @State private var isPresentingCreationView = false
    @State private var rainbowColors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple]
    @State private var currentHeaderText: String = ""
    @State private var remainingHeaderTexts: [String] = []
    @State private var showThankYouMessage: Bool = false
    @State private var headerTextOffset: CGFloat = 300 // Startposition für die Animation

    // Header Text und Sprachen
    private let headerTexts: [String] = [
        "Wer Schaut?", // Deutsch
        "Who’s Watching?", // Englisch
        "Qui Regarde?", // Französisch
        "¿Quién Mira?", // Spanisch
        "誰が見ていますか？", // Japanisch
        "谁在看？", // Chinesisch
        "Кто смотрит?", // Russisch
        "Quem está assistindo?", // Portugiesisch
        "Kim İzliyor?", // Türkisch
        "Kto ogląda?", // Polnisch
        "Cine te ve?", // Rumänisch
        "Kto sa pozerá?", // Slowakisch
        "Vem que está assistindo?", // Brasilianisches Portugiesisch
        "Kto gleda?", // Slowenisch
        "Kdo se dívá?", // Tschechisch
        "Kdo gledate?", // Serbisch
        "Cine está mirando?", // Spanisch (alternative)
        "Кто смотрит?", // Russisch (alternative)
        "Kdo gleda?", // Slowenisch (alternative)
            "M谁在看？", // Chinesisch (alternative)
    ]

    // Dankesnachricht
    private let thankYouMessages: [String] = [
        "Danke an ChatGPT für die große Hilfe!", // Deutsch
        "Thanks to ChatGPT for the great help!" // Englisch
    ]

    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                VStack {
                    // Header-Bereich mit Animation
                    headerView

                    // Secret Message nur zufällig im Header
                    if showThankYouMessage {
                        thankYouMessageView
                    }

                    profileGrid
                }
            }
            .navigationTitle("Profile auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.white)
            .onAppear {
                setupHeaderTexts() // Header-Texts initial setzen
                updateHeaderText() // Header-Text initial setzen
                startHeaderTextAnimation() // Header-Text Animation starten
            }
        }
        .accentColor(.red) // Rot für Navigation-Link-Farbe
    }

    private var headerView: some View {
        VStack(spacing: 10) {
            Text(currentHeaderText)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
                .offset(x: headerTextOffset)
                .onAppear {
                    // Zufällig Dankesnachricht zeigen
                    if Bool.random() {
                        showThankYouMessage = true
                    }
                }
                .onChange(of: currentHeaderText) { _ in
                    // Animation starten, wenn sich der Header-Text ändert
                    withAnimation(.easeInOut(duration: 1)) {
                        headerTextOffset = 0 // Zum Mittelpunkt bewegen
                    }
                }
                .onAppear {
                    headerTextOffset = 300 // Startposition für die Animation
                }
        }
        .padding(.bottom, 20)
    }

    private var thankYouMessageView: some View {
        Text(thankYouMessages.randomElement() ?? "")
            .font(.subheadline)
            .foregroundColor(.green)
            .padding(.bottom)
    }

    private var profileGrid: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                ForEach(profileManager.profiles) { profile in
                    NavigationLink(destination: Text("Hier könnte dein Inhalt für \(profile.name) sein")) {
                        profileCard(for: profile)
                    }
                }

                // Profil hinzufügen Button mit eigenem Rand
                addProfileButton
            }
            .padding()
            .frame(maxWidth: .infinity) // Maximale Breite einnehmen für Zentrierung
        }
    }

    private func profileCard(for profile: Profile) -> some View {
        VStack {
            ZStack {
                // Statischer Regenbogenrand
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: rainbowGradient()), startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 5
                    )
                    .frame(width: 110, height: 110)

                // Profilbild
                if let imageData = profile.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage) // Erstelle ein Image aus UIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 4)
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .shadow(color: .black, radius: 4)
                }
            }

            Text(profile.name)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.clear)
        .cornerRadius(10)
        .transition(.scale)
        .animation(.easeInOut)
    }

    private var addProfileButton: some View {
        Button(action: {
            isPresentingCreationView = true
        }) {
            VStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .overlay(
                        Text("+")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    )
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 3) // Einfärbung des Rahmens
            )
        }
        .sheet(isPresented: $isPresentingCreationView) {
            ProfileCreationView()
                .environmentObject(profileManager) // Übergebe das Environment Object hier
        }
    }

    private func startHeaderTextAnimation() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            updateHeaderText()
        }
    }

    private func setupHeaderTexts() {
        // Header-Texts mit Deutsch und Englisch als ersten zwei Sprachen
        remainingHeaderTexts = ["Wer Schaut?", "Who’s Watching?"] + headerTexts.shuffled().filter { $0 != "Wer Schaut?" && $0 != "Who’s Watching?" }
        currentHeaderText = remainingHeaderTexts.removeFirst() // Ersten Header-Text setzen
    }

    private func updateHeaderText() {
        // Header-Text anpassen
        if remainingHeaderTexts.isEmpty {
            setupHeaderTexts() // Header-Texts zurücksetzen, wenn alle verwendet wurden
        }
        withAnimation {
            currentHeaderText = remainingHeaderTexts.removeFirst() // Nächsten Header-Text setzen
        }
    }

    private func rainbowGradient() -> [Color] {
        // Rotiert die Regenbogenfarben basierend auf dem aktuellen Index
        return rainbowColors
    }
}
