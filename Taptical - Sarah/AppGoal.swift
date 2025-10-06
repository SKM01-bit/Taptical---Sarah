//
//  AppGoal.swift
//  Taptical - Sarah
//
//  Created by Jana Abdulaziz Malibari on 06/10/2025.
//

import SwiftUI

struct AppGoal: View {
    @State private var showTaptii = false
    @State private var pulse = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                    Image("Background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    VStack {
                        ZStack {
                            Image("Bubble")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 450)
                                .position(x:200, y: 250)
                            Text("Hi, I'm TAPTI ^_^")
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                                .frame(width: 330, height: 450)
                                .position(x:105, y: 148)
                                .foregroundColor(Color("M_Color"))
                            
                            Text("An over-thinker friend, just like most of us.and this game is designed to help engaging your mind through solving puzzle.")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .frame(width: 330, height: 450)
                                .position(x:200, y: 210)
                                .foregroundColor(Color("M_Color"))

                            
                            Image("Taptii")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 450, height: 450)
                                .offset(y: -20)
                                .transition(.opacity)
                                .position(x:200, y: 550)
                            
                            
                            Image("Glow")
                                .resizable()
                                .frame(width: 150, height: 180)
                                .scaledToFit()
                                .scaleEffect(pulse ? 1.1 : 0.9)   // Scale up and down
                                    .opacity(pulse ? 1.0 : 0.7)       // Slight fade in and out
                                    .animation(
                                        .easeInOut(duration: 1).repeatForever(autoreverses: true),
                                        value: pulse
                                    )
                                    .onAppear {
                                        pulse = true
                                    }
                                    .position(x: 255, y:590)
                                    .offset(x: 0, y: 0)
                        }
                       
                        NavigationLink(destination: Round1()) {
                            Text("Press to start")
                                .foregroundColor(.gray)
                                .padding(.bottom, 50)
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
                
            }
            .navigationBarBackButtonHidden(true)
        }
    
}
#Preview {
    AppGoal()
}
