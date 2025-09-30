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




    let image = Image("Taptii")
    var body: some View {
        
      NavigationStack {
                    ZStack {
                        Image("Background")
                                        .resizable()
                                        .scaledToFill()
                                        .ignoresSafeArea()
                        // Animated image
                        VStack {
                         AnimatedTaptii()
                        }
                        .allowsHitTesting(false)

                        // App name
                        VStack(spacing:0){
                                        Image("App name")
                                            .scaledToFit()
                                            .frame(width: 100, height: 0)
                                            .position(x: 190, y: 677) // ← X and Y coordinates
                                    }.allowsHitTesting(false)

                        // ✅ Navigation Button
                     VStack {
                         Image(isTapped ?"شعاع":"taptii")
                             .onTapGesture {
                                 isTapped.toggle()
                             }
                            Spacer()
                            NavigationLink(destination: SecondPage()) {
                                Text("Go to Second Page")
                                    .font(.headline)
                                    .foregroundColor(.clear)
                                    .padding()
                                    .background(Color.clear)
                                    .cornerRadius(10)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .padding(.bottom, 40)
                        }
                   }
                }
            }
    }
        
    
#Preview {
    ContentView()
}


