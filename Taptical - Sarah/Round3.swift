//
//  Round4.swift
//  Taptical - Sarah
//
//  Created by Jana Abdulaziz Malibari on 03/10/2025.
//

import SwiftUI
import Combine

struct Tile: Identifiable {
    let id = UUID()
    let number: Int
    var isTapped: Bool = false
    var position: CGPoint
}

class QuestionManager: ObservableObject {
    @Published var QuestionsFun: [String] = []

    init() {
        loadQuestions()
    }

    private func loadQuestions() {
        if let url = Bundle.main.url(forResource: "QuestionsFun", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                QuestionsFun = try JSONDecoder().decode([String].self, from: data)
            } catch {
                print("Failed to decode questions.json:", error)
            }
        } else {
            print("QuestionsFun.json not found.")
        }
    }

    func randomQuestion() -> String {
        QuestionsFun.randomElement() ?? "No questions available."
    }
}

struct Round3: View {

    @State private var Sound = false
    @State private var isPaused = false
    
    
    @State private var tiles: [Tile] = []
    @State private var currentNumber: Int = 1
    @State private var glow = false
    @State private var bounce = false
    
    @State private var round = 1
    let maxRounds = 5
    
    @State private var levelCleared = false
    
    @StateObject private var questionManager = QuestionManager()
    @State private var displayedQuestion = ""
    
    @State private var navigateToMainMenu = false

    
    var body: some View {
        
        NavigationStack {
            ZStack {
                NavigationLink(destination: ContentView(), isActive: $navigateToMainMenu) {
                    EmptyView()
                }
                
                Color("Bg_Color")
                    .ignoresSafeArea()
                Image("Fun_Bg" )
                    .ignoresSafeArea()
                
                if levelCleared {
                    levelClearView
                    
                } else {
                    gameView
                }
                
                ZStack(alignment: .topTrailing) {
                    Color.clear // Needed to enable alignment
                    
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
                                        .foregroundColor(Color("Btn_Color"))
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
                                    .foregroundColor(Color("Btn_Color"))
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 70)
                        
                        Spacer()
                    }
                }
                .ignoresSafeArea()
                // Pause Overlay
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
            }
            .onAppear {
                startNewRound()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var gameView: some View {
        ZStack{
            ForEach(tiles) { tile in
                Image(tile.isTapped ? "C\(tile.number)" : "\(tile.number)")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .position(tile.position)
                    .onTapGesture {
                        handleTap(tile)
                    }
                    .animation(.easeInOut, value: tile.isTapped)
            }
        }
    }
    var levelClearView: some View {
        
        ZStack(){
            Color("Bg_Color").ignoresSafeArea()
            Image("Fun_Bg")
                .opacity(84/255)
                .ignoresSafeArea()
            Image("Confitti")
                .resizable()
                .scaledToFit()
                .frame(width: 990, height: 1000)
                .position(x:160, y:550)
            
            
            VStack{
                Image("Chibi_Tapti")

                    .resizable()
                .frame(width: 400, height: 400)
                    .shadow(color: Color("Glow").opacity(glow ? 231/255 : 150/255), radius: glow ? 5 : 1, x: 0, y: 9)
                    .offset(y: bounce ? -7 : 7) // Move up and down
                    .animation(
                        .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                        value: bounce
                    )
                
                Text("Awesome!")
                    .font(.system(size: 45, weight: .heavy, design: .rounded) )
                    .bold()
                    .foregroundColor(Color("Font"))
                    .shadow(color: Color("Glow").opacity(glow ? 231/255 : 120/255), radius: glow ? 5 : 1, x: 0, y: 4)
                    .animation(.easeInOut(duration: 0.5), value: glow)
                
                Text("For The Last Question")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundColor(Color("Glow"))
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                if !displayedQuestion.isEmpty {
                    Text(displayedQuestion)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Color("Maroon"))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                }
                
                Text("Play Again?")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color("Glow"))
                    .padding(.top, 20)
                
                
                Button(action: {
                    navigateToMainMenu = true
                }) {
                    
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .font(.title)
                        .bold()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color("Glow")) // icon color
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
//        .padding(.horizontal, 30)
//        .padding(.top, 50)
    }
    func startNewRound() {
        tiles.removeAll()
        
        // Pick a random number between 1 and 4
        currentNumber = Int.random(in: 1...4)
        
        // Generate tiles equal to that number
        for _ in 0..<currentNumber {
            let randomX = CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50))
            let randomY = CGFloat.random(in: 150...(UIScreen.main.bounds.height - 150))
            
            let tile = Tile(
                number: currentNumber,
                position: CGPoint(x: randomX, y: randomY)
            )
            tiles.append(tile)
        }
    }
    
    func handleTap(_ tile: Tile) {
        // Mark tile as tapped (correct)
        if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
            tiles[index].isTapped = true
            if tiles.allSatisfy({ $0.isTapped }) {
                // Delay to show tapped state, then move to next round
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
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
    
    func resetGame() {
        round = 1
        levelCleared = false
        displayedQuestion = ""
        startNewRound()
    }
}

#Preview {
    Round3()
}

