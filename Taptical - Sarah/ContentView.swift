//
//  ContentView.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 03/04/1447 AH.
//

import SwiftUI

struct ContentView: View {
    @State private var shake: Bool = false
    @State private var pulse = false
    @State private var navigate = false
    @State private var isTapped = false
    @State private var isShowingSplash = true

        private let dripImages = ["drip1", "drip3", "drip4"]
        private let dripYOffset: [CGFloat] = [ -300, 0, 150 ]
        
        @State private var currentFrame = 0
        @State private var showTaptii = false
        let frameDuration = 0.5
        
        var body: some View {
            ZStack {

            Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                // Show drip image at correct position
                ForEach(0..<dripImages.count, id: \.self) { index in
                    if index == currentFrame {
                        Image(dripImages[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .offset(x: 0, y: dripYOffset[index])
                            .transition(.opacity)
                    }
                }

                // Taptii logo after all drips
                HStack(spacing: 16){
                    if showTaptii {
                    Image("Taptii")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                    // .position(x:100,y:100)
                        .transition(.opacity)
                        .scaleEffect(pulse ? 1.1 : 0.9)
                        .opacity(showTaptii ? 1 : 0)
                        .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
                        .onAppear {
                            pulse = true
                        }
                    Text("Press to start")
                        .foregroundColor(.gray)
                       // .position(x:100,y:100)
                }}
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                startDripSequence()
            }
        }
        
        func startDripSequence() {
            // Loop through each drip with delay
            for i in 0..<dripImages.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * frameDuration) {
                    currentFrame = i
                }
            }

            // Show Taptii after the last drip
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(dripImages.count) * frameDuration) {
                currentFrame = -1 // hide all drips
                showTaptii = true
            }
        }
    }
