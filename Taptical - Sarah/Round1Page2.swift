//
//  FourthPage.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 08/04/1447 AH.
//

import SwiftUI

struct R1P1: View {
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
                    .position(x: 100, y: 200)
                    .onTapGesture {
                        isTapped.toggle()
                        tapCount += 1
                        
                        if tapCount == maxTaps {
                            navigate = true
                        }
                    }

                // Hidden NavigationLink that activates when navigate == true
                NavigationLink(destination: FourthPage(), isActive: $navigate) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    R1P1()
}
