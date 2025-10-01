//
//  SecondPage.swift
//  Taptical - Sarah
//
//  Created by Sarah Khalid Almalki on 06/04/1447 AH.
//

import SwiftUI

struct SecondPage: View {
    var body: some View {

        NavigationStack{
            ZStack {
                
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Taptii image
                VStack(spacing: 0) {
                    Image("Taptii")
                        .resizable()
                        .scaledToFit()
                    .frame(width: 400, height: 400)}
                .allowsHitTesting(false)
                
                .allowsHitTesting(false)
                // App name
                VStack(spacing:0){
                    Image("App name")
                        .scaledToFit()
                        .frame(width: 100, height: 0)
                        .position(x: 190, y: 650) // ← X and Y coordinates
                }
                VStack{
                    goldenPulse()
                    .position(x: 238, y: 499)
                }
                
                VStack {
                    Spacer()
                    NavigationLink(destination: Round1Page1()) {
                        Text("Go to Third Page")
                            .foregroundColor(.clear)
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .padding(.bottom, 40)
                }}}
    }}
    
    #Preview {
        SecondPage()
    }
    

