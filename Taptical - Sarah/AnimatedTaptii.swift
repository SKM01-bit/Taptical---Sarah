//
//  AnimatedTaptii.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 06/04/1447 AH.
//

import SwiftUI

struct AnimatedTaptii: View {
    @State private var pulse = false

    var body: some View {
        Image("Taptii")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .scaleEffect(pulse ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
                    .onAppear {
                        pulse = true
            }
       
    }
}
