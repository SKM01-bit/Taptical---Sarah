//
//  ROUND1.swift
//  Taptical - Sarah
//
//  Created by Najla Almuqati on 13/04/1447 AH.
//

import SwiftUI

struct NumberImage {
    let normal: String
    let tapped: String
}

struct Screen {
    let numbers: [NumberImage]
}

struct NotificationView: View {
    var title: String
    var message: String
    var onClose: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image("tapti")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

struct ROUND1: View {
    @State private var currentScreen = 0
    @State private var tappedIndices: Set<Int> = []
    @State private var showPopup = false
    
    let numberSize: CGFloat = 40
    
    let screens: [Screen] = [
        Screen(numbers: [NumberImage(normal: "tap1", tapped: "R1")]),
        Screen(numbers: [
            NumberImage(normal: "tap2", tapped: "R2"),
            NumberImage(normal: "tap2", tapped: "R2"),
            NumberImage(normal: "tap2", tapped: "R2")
        ]),
        Screen(numbers: [
            NumberImage(normal: "tap3", tapped: "R3"),
            NumberImage(normal: "tap3", tapped: "R3")
        ]),
        Screen(numbers: []) // الشاشة الأخيرة
    ]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if currentScreen == screens.count - 1 {
                    //  آخر سكرين
                    ZStack {
                        Color.backgroundBeige

                        Image("waves1") // الأمواج الشفافة
                            .resizable()
                            .scaledToFill()
                            .opacity(0.6)
                            .ignoresSafeArea()

                        Image("QU1") // العناصر الزرقاء
                            .resizable()
                            .scaledToFill()
                            .opacity(0.9)
                            .ignoresSafeArea()

                        VStack(spacing: 20) {
                            Spacer()
                            
                            
                            Image("QU")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .shadow(radius: 10)
                                .padding(.bottom, 10)

                            // النصوص
                            Text("Awesome!")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Color.blue.opacity(0.9))
                                .shadow(radius: 2)

                            VStack(spacing: 6) {
                                Text("For the last question")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Text("Which worry feels heavier\nthan it really is?")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                            }

                            Spacer()

                            // زر Press to continue
                            Button(action: {
                                currentScreen = 0
                            }) {
                                Text("Press to continue")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 30)
                                    .background(Color.purple)
                                    .cornerRadius(20)
                                    .shadow(radius: 3)
                            }
                            .padding(.bottom, 60)
                        }
                        .padding(.horizontal, 30)
                    }
                    .transition(.opacity)
                    .animation(.easeInOut, value: currentScreen)
                } else {
                    // 🔹 باقي الشاشات
                    Color.backgroundBeige

                    Image("FirstRound")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                    let positions = predefinedPositions(for: geo.size,
                                                        count: screens[currentScreen].numbers.count)

                    ForEach(0..<screens[currentScreen].numbers.count, id: \.self) { index in
                        let num = screens[currentScreen].numbers[index]
                        let pos = positions[index]

                        Image(tappedIndices.contains(index) ? num.tapped : num.normal)
                            .resizable()
                            .scaledToFit()
                            .frame(width: numberSize, height: numberSize)
                            .position(pos)
                            .onTapGesture {
                                tappedIndices.insert(index)
                                if tappedIndices.count == screens[currentScreen].numbers.count {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                        tappedIndices.removeAll()
                                        if currentScreen + 1 < screens.count {
                                            currentScreen += 1
                                        }
                                    }
                                }
                            }
                    }

                    if showPopup {
                        VStack {
                            NotificationView(
                                title: "TAPTI!",
                                message: "Find the number, Tap it and have fun!!",
                                onClose: { showPopup = false }
                            )
                            .padding(.top, 20)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(), value: showPopup)
                    }
                    
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showPopup = true
                }
            }
        }
    }
    
    // 🔹 توزيع الأرقام على الشاشة
    private func predefinedPositions(for size: CGSize, count: Int) -> [CGPoint] {
        var positions: [CGPoint] = []

        if count == 1 {
            positions.append(CGPoint(x: size.width / 2, y: size.height / 2))
        } else if count == 2 {
            positions.append(CGPoint(x: size.width * 0.25, y: size.height / 2))
            positions.append(CGPoint(x: size.width * 0.75, y: size.height / 2))
        } else if count == 3 {
            positions.append(CGPoint(x: size.width * 0.25, y: size.height * 0.3))
            positions.append(CGPoint(x: size.width * 0.75, y: size.height * 0.3))
            positions.append(CGPoint(x: size.width * 0.5, y: size.height * 0.75))
        } else {
            for i in 0..<count {
                let x = size.width * (CGFloat(i + 1) / CGFloat(count + 1))
                let y = size.height * 0.5
                positions.append(CGPoint(x: x, y: y))
            }
        }
        return positions
    }
}

#Preview {
    ContentView()
}

