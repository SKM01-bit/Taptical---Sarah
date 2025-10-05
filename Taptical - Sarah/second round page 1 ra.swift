import SwiftUI

// كل عنصر يمثل رقم مفرغ في الشاشة
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

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // الخلفية الأساسية تغطي الشاشة كاملة
                Image("background2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea()

                // الصورة الثانية تظهر فوق الخلفية
                Image("r2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()

                // عرض الأرقام العشوائية
                ForEach(numberItems) { item in
                    Image(item.isTapped ? "C\(currentNumber!)" : "\(currentNumber!)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40) // حجم أصغر
                        .rotationEffect(Angle(degrees: item.rotation)) // دوران عشوائي
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

    // بدء راوند جديد برقم جديد عشوائي من 1 إلى 4
    func startNextRound() {
        guard usedNumbers.count < 4 else {
            // إذا خلصت الأربع أرقام، نعيد اللعب من جديد
            usedNumbers = []
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                startNextRound()
            }
            return
        }

        var newNumber: Int
        repeat {
            newNumber = Int.random(in: 1...4)
        } while usedNumbers.contains(newNumber)

        currentNumber = newNumber
        usedNumbers.append(newNumber)

        numberItems = generateRandomPositions(for: newNumber)
    }

    // توليد أماكن ودوران عشوائي لكل نسخة من الرقم
    func generateRandomPositions(for count: Int) -> [NumberItem] {
        var items: [NumberItem] = []

        for _ in 0..<count {
            let x = CGFloat.random(in: 50...(screenSize.width - 50))
            let y = CGFloat.random(in: 120...(screenSize.height - 120))
            let angle = Double.random(in: -30...30) // دوران عشوائي
            items.append(NumberItem(position: CGPoint(x: x, y: y), rotation: angle))
        }

        return items
    }

    // التعامل مع الضغط على رقم
    func handleTap(on id: UUID) {
        guard let index = numberItems.firstIndex(where: { $0.id == id }) else { return }
        if numberItems[index].isTapped || isTransitioning { return }

        numberItems[index].isTapped = true

        // إذا ضغط المستخدم على كل النسخ
        if numberItems.allSatisfy({ $0.isTapped }) {
            isTransitioning = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                numberItems = []
                isTransitioning = false
                startNextRound()
            }
        }
    }
}

#Preview {
    MyContentView()
}
