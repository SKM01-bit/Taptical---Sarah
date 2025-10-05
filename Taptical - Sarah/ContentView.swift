//
//  ContentView.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 03/04/1447 AH.
//

import SwiftUI

struct ContentView: View {
    @State private var currentFrame = 0
    @State private var showTaptii = false
    @State private var didRunDripSequence = false
    @State private var showAppName = false
    @State private var showGlow = false
    @State private var pulse = false

    
    private let dripImages = ["drip1", "drip3", "drip4"]
    private let dripYOffset: [CGFloat] = [-400, -100, 50]
    
    let frameDuration = 0.6
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background switches based on showTaptii
                if showTaptii {
                    Image("Background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                } else {
                    Color.backgroundBeige
                        .ignoresSafeArea()
                }
                
                // Drip images animation
                ForEach(0..<dripImages.count, id: \.self) { index in
                    if index == currentFrame {
                        Image(dripImages[index])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .offset(y: dripYOffset[index])
                            .transition(.opacity)
                            .animation(.easeInOut(duration: frameDuration), value: currentFrame)
                    }
                }
                
                // Show Taptii logo and button after drip animation
                if showTaptii {
                    VStack {
                        Spacer()
                        
                        ZStack {
                            Image("Taptii")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 500, height: 500)
                                .offset(y: -20)
                                .transition(.opacity)

                            goldenPulse() // Now overlays Taptii
                        }
                        
                        Image("App name")
                            .opacity(showAppName ? 1 : 0)
                            .animation(.easeIn(duration: 1), value: showAppName)
                            .frame(height: 100)

                        NavigationLink(destination: Round1Page1()) {
                            Text("Press to start")
                                .foregroundColor(.gray)
                                .padding(.bottom, 150)
                        }
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.9), value: showTaptii)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                if !didRunDripSequence {
                    startDripSequence()
                    didRunDripSequence = true
                } else {
                    currentFrame = -1
                    showTaptii = true
                }
            }
        }
    }
    
    func startDripSequence() {
        for i in 0..<dripImages.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * frameDuration) {
                withAnimation {
                    currentFrame = i
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(dripImages.count) * frameDuration) {
            withAnimation {
                currentFrame = -1
                showTaptii = true
            }
            
            // Show Glow a bit after Taptii
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation {
                    showGlow = true
                }
            }

            // Show app name after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showAppName = true
                }
            }
        }
    }

    
    func goldenPulse() -> some View {
        Image("Glow")
            .resizable()
            .frame(width: 200, height: 200)
            .offset(x:60,y: 60)
            .scaledToFit()
            .scaleEffect(pulse ? 1.1 : 0.9)
            .opacity(showGlow ? 1 : 0) // Fade in
            .animation(.easeIn(duration: 1), value: showGlow) // Smooth fade
            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
            .onAppear {
                pulse = true
            }
    }

    
    
}
