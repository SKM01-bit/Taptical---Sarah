import SwiftUI

// يمثل كل رقم في الشاشة
struct NumberItem: Identifiable {
    let id = UUID()
    var position: CGPoint
    var rotation: Double
    var isTapped: Bool = false
}

struct MyContentView: View {
    @State private var usedNumbers: [Int] = []
    @State private var currentNumber: Int? = nil
    @State private var numberItems: [NumberItem] = []
    @State private var screenSize: CGSize = .zero
    @State private var isTransitioning = false
    @State private var isGameOver = false

    let itemSize: CGFloat = 40 // حجم الرقم (مهم لمنع التراكب)
    let paddingBetweenItems: CGFloat = 50 // المسافة الدنيا بين الأرقام

    var body: some View {
        if isGameOver {
            GameOverView()
        } else {
            GeometryReader { geometry in
                ZStack {
                    Image("background2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .ignoresSafeArea()

                    Image("r2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()

                    // عرض الأرقام
                    ForEach(numberItems) { item in
                        Image(item.isTapped ? "C\(currentNumber!)" : "\(currentNumber!)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: itemSize, height: itemSize)
                            .rotationEffect(Angle(degrees: item.rotation))
                            .position(item.position)
                            .onTapGesture {
                                handleTap(on: item.id)
                            }
                            .animation(.easeInOut, value: item.isTapped)
                    }
                }
                .onAppear {
                    screenSize = geometry.size
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        startNextRound()
                    }
                }
            }
        }
    }

    // بدء راوند جديد
    func startNextRound() {
        if usedNumbers.count >= 5 {
            isGameOver = true
            return
        }

        var newNumber: Int
        repeat {
            newNumber = Int.random(in: 1...4)
        } while usedNumbers.contains(newNumber)

        currentNumber = newNumber
        usedNumbers.append(newNumber)

        numberItems = generateNonOverlappingPositions(for: newNumber)
    }

    // توليد أماكن متباعدة لا تتداخل
    func generateNonOverlappingPositions(for count: Int) -> [NumberItem] {
        var items: [NumberItem] = []
        let maxAttempts = 100

        for _ in 0..<count {
            var position: CGPoint
            var attempts = 0

            repeat {
                let x = CGFloat.random(in: itemSize...(screenSize.width - itemSize))
                let y = CGFloat.random(in: itemSize + 100...(screenSize.height - itemSize - 100))
                position = CGPoint(x: x, y: y)
                attempts += 1
            } while items.contains(where: { distance(from: $0.position, to: position) < paddingBetweenItems }) && attempts < maxAttempts

            let angle = Double.random(in: -30...30)
            items.append(NumberItem(position: position, rotation: angle))
        }

        return items
    }

    // حساب المسافة بين نقطتين
    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
    }

    // التعامل مع الضغط
    func handleTap(on id: UUID) {
        guard let index = numberItems.firstIndex(where: { $0.id == id }) else { return }
        if numberItems[index].isTapped || isTransitioning { return }

        numberItems[index].isTapped = true

        // إذا كل الأرقام تم الضغط عليها → ننتقل فورًا للراوند التالي
        if numberItems.allSatisfy({ $0.isTapped }) {
            isTransitioning = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                numberItems = []
                isTransitioning = false
                startNextRound()
            }
        }
    }
}

// صفحة النهاية
struct GameOverView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("انتهت اللعبة!")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    MyContentView()
}
