//
//  thirdPage.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 06/04/1447 AH.
//

import SwiftUI

struct Round1Page1: View {
    @State private var isTapped = false
    @State private var tapCount = 0
    @State private var navigate = false

    let maxTaps = 2
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("FirstRound")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Image(isTapped ? "Yellow2" : "White2")
                    .resizable()
                    .frame(width: 60, height: 60) // 👈 Set your desired size here
                    .position(x: 350, y: 100)
                    .onTapGesture {
                        isTapped.toggle()
                        tapCount += 1
                        
                        if tapCount >= maxTaps {
                            navigate = true
                        }
                    }

                // Hidden NavigationLink that activates when navigate == true
                NavigationLink(destination: Round1Page2(), isActive: $navigate) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    Round1Page1()
}
