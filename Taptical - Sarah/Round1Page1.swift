//
//  thirdPage.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 06/04/1447 AH.
//


import SwiftUI
import Combine
import AVFoundation  // <-- Don't forget this!

// MARK: - Tile Struct
struct Tile1: Identifiable {
    let id = UUID()
    let number: Int
    var isTapped: Bool = false
    var position: CGPoint
}
class QuestionManager1: ObservableObject {
    @Published var QuestionsDeep: [String] = []

    init() {
        loadQuestions()
    }

    private func loadQuestions() {
        if let url = Bundle.main.url(forResource: "QuestionsDeep", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                QuestionsDeep = try JSONDecoder().decode([String].self, from: data)
            } catch {
                print("Failed to decode QuestionsDeep.json:", error)
            }
        } else {
            print("QuestionsDeep.json not found.")
        }
    }

    func randomQuestion() -> String {
        QuestionsDeep.randomElement() ?? "No questions available."
    }
}

// MARK: - Round1Page1 View
struct Round1Page1: View {
    @State private var Sound = false
    @State private var isPaused = false
    
    @State private var tiles: [Tile1] = []
    @State private var currentNumber: Int = 1
    @State private var showPopup = false
    @State private var glow = false
    @State private var bounce = false
    
    @State private var round = 1
    let maxRounds = 5
    
    @StateObject private var questionManager = QuestionManager1()
    @State private var displayedQuestion = ""
    
    @State private var levelCleared = false
    @State private var navigateToNextPage = false
    @State private var navigateToMainMenu = false

    
    // Audio player for tap sound
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                NavigationLink(destination: ContentView(), isActive: $navigateToMainMenu) {
                    EmptyView()
                }

                NavigationLink(destination: Round2(), isActive: $navigateToNextPage) {
                    EmptyView()
                }
                Image("FirstRound")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                if levelCleared {
                    levelClearView
                } else {
                    gameView
                }
            }
            .onAppear {
                startNewRound()
            }
        }
//        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Game View
    var gameView: some View {
        ZStack {
            
            VStack {
                HStack {
                    // Pause Button (only in gameplay)
                    if !levelCleared {
                        Button(action: {
                            isPaused = true
                        }) {
                            Image(systemName: "pause.fill")
                                .font(.title)
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("DGlow"))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        Sound.toggle()
                        print("Speaker toggled: \(Sound)")
                    }) {
                        Image(systemName: Sound ? "speaker.slash.fill" : "speaker.2.fill")
                            .font(.title)
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("DGlow"))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 70)
                
                Spacer()
            }
            
            // Main tiles
            ForEach(tiles) { tile in
                Image(tile.isTapped ? "C\(tile.number)" : "\(tile.number)")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .position(tile.position)
                    .onTapGesture {
                        playSound(named: "tap")
                        handleTap(tile)
                    }
            }
            
            if isPaused {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Paused")
                        .font(.system(size: 55, weight: .heavy, design: .rounded))
                        .foregroundColor(Color("Bg_Color"))
                        .padding(.bottom, 40)
                    
                    Button("Resume") {
                        isPaused = false
                    }
                    .frame(maxWidth: 200)
                    .padding()
                    .background(Color("Bg_Color").opacity(0.45))
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
                    .clipShape(Capsule())
                    
                    Button("Quit") {
                        navigateToMainMenu = true
                        isPaused = false
                    }
                    .frame(maxWidth: 200)
                    .padding()
                    .background(Color("Bg_Color").opacity(0.45))
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
                    .clipShape(Capsule())
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
            }

            // Popup
            if showPopup {
                ZStack(alignment: .topLeading) {
                    // 👇 Popup background
                    NotificationView(
                        title: "TAPTI!",
                        message: "Find the number, Tap it and have fun!!",
                        onClose: { showPopup = false }
                    )
                    .padding(.top, 30) // leaves space for the image to overlap

                    // 👇 Image overlapping the top-left corner
                    Image("Chibi_Tapti") // replace with your actual asset name
                        .resizable()
                        .frame(width: 50, height: 50)
                        .offset(x: 30, y: 60) // adjust to overlap nicely
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 100) // move the whole popup a bit down
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: showPopup)
                .zIndex(1)
            }

        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showPopup = true
            }
        }
    }

       

    

    // MARK: - Level Cleared View
    var levelClearView: some View {
        ZStack {
            Color("Bg_Color").ignoresSafeArea()
            Image("FirstRound")
                .opacity(84/255)
                .ignoresSafeArea()
            Image("Group1")
                .resizable()
                .scaledToFit()
                .frame(width: 990, height: 1000)
                .position(x:200, y:450)

            VStack {
                Image("Chibi_Tapti")
                    .resizable()
                    .frame(width: 400, height: 400)
                    .shadow(color: Color("DGlow").opacity(glow ? 231/255 : 150/255), radius: glow ? 5 : 1, x: 0, y: 9)
                    .offset(y: bounce ? -7 : 7)
                    .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: bounce)

                Text("GREAT!")
                    .font(.system(size: 45, weight: .heavy, design: .rounded))
                    .foregroundColor(Color("DFont"))
                    .shadow(color: Color("DGlow").opacity(glow ? 231/255 : 120/255), radius: glow ? 5 : 1, x: 0, y: 4)
                    .animation(.easeInOut(duration: 0.5), value: glow)

                Text("For The Next Question")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(Color("DGlow"))
                    .padding(.top, 5)
                    .padding(.bottom, 5)

                if !displayedQuestion.isEmpty {
                    Text(displayedQuestion)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color("Maroon"))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }

                Text("Continue")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color("DGlow"))
                    .padding(.top, 20)

                HStack(spacing: 40) {
                    // زر للانتقال للصفحة التالية ✅
                    Button(action: {
                        navigateToNextPage = true
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                            .foregroundColor(Color("DGlow"))
                            .padding(2)
                    }
                }
            }
            .padding(.top, 60)
            .padding(.bottom, 100)
            .onAppear {
                bounce = true
                glow = true
                displayedQuestion = questionManager.randomQuestion()
            }
        }
    }

    // MARK: - Setup & Logic
    func startNewRound() {
        tiles.removeAll()

        currentNumber = Int.random(in: 1...4)

        for _ in 0..<currentNumber {
            let randomX = CGFloat.random(in: 60...(UIScreen.main.bounds.width - 60))
            let randomY = CGFloat.random(in: 200...(UIScreen.main.bounds.height - 150))

            let tile = Tile1(
                number: currentNumber,
                position: CGPoint(x: randomX, y: randomY)
            )
            tiles.append(tile)
        }
    }

    func handleTap(_ tile: Tile1) {
        if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
            tiles[index].isTapped = true

            if tiles.allSatisfy({ $0.isTapped }) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    nextRound()
                }
            }
        }
    }

    func nextRound() {
        if round >= maxRounds {
            levelCleared = true
        } else {
            round += 1
            startNewRound()
        }
    }

}
    
    // MARK: - Sound Playback Function
    func playSound(named soundName: String) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: "mp3") else {
            print("Sound file \(soundName).mp3 not found")
            return
        }
        let url = URL(fileURLWithPath: path)

        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
#Preview {
    Round1Page1()
}
