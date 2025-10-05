//
//  thirdPage.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 06/04/1447 AH.
//


import SwiftUI
import AVFoundation  // <-- Don't forget this!

// MARK: - Tile Struct
struct Tile1: Identifiable {
    let id = UUID()
    let number: Int
    var isTapped: Bool = false
    var position: CGPoint
}

// MARK: - Round1Page1 View
struct Round1Page1: View {
    @State private var tiles: [Tile1] = []
    @State private var currentNumber: Int = 1
    @State private var showPopup = false
    
    @State private var round = 1
    let maxRounds = 5
    
    @State private var levelCleared = false
    @State private var navigateToNextPage = false
    
    // Audio player for tap sound
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink(destination: Round1Page2(), isActive: $navigateToNextPage) {
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
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Game View
    var gameView: some View {
        ZStack {
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
                        .offset(x: 30, y: -20) // adjust to overlap nicely
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
        VStack(spacing: 20) {
            Text("Level Complete!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Button("Next") {
                navigateToNextPage = true
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7).ignoresSafeArea())
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
    
    // MARK: - Sound Playback Function
    func playSound(named soundName: String) {
        guard let path = Bundle.main.path(forResource: soundName, ofType: "mp3") else {
            print("Sound file \(soundName).mp3 not found")
            return
        }
        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
}

#Preview {
    Round1Page1()
}
