//
//  thirdPage.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 06/04/1447 AH.
//

import SwiftUI

struct ThirdPage: View {
    var body: some View {
        ZStack {
            // Full-screen pink background
            Color(red: 0.2, green: 0.50, blue: 0.6) // light pink
                .ignoresSafeArea()

            // Centered bold green text
            Text("^^\n Hello, This is the third page\n\n🌸🩰✨")
                .foregroundColor(.white)
                .bold()
                .font(.system(size: 23))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

#Preview {
    ThirdPage()
}
