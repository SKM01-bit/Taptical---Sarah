//
//  FourthPage.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 08/04/1447 AH.
//

import SwiftUI

struct Round1Page2: View {
    @State private var isTapped = false
    @State private var tapCount = 0
    @State private var navigate = false

    let maxTaps = 3
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("FirstRound")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Image(isTapped ? "Yellow3" : "White3")
                    .resizable()
                    .frame(width: 60, height: 60) // 👈 Set your desired size here
                    .position(x: 100, y: 200)
                    .onTapGesture {
                        isTapped.toggle()
                        tapCount += 1
                        
                        if tapCount == maxTaps {
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
    Round1Page2()
}
