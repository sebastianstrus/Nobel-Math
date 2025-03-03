//
//  ContentView.swift
//  Matematik2
//
//  Created by Sebastian Strus on 2025-02-04.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State private var additionCompleted = false
    @State private var subtractionCompleted = false
    @State private var multiplicationCompleted = false
    @State private var divisionCompleted = false
    
    var body: some View {
        if additionCompleted && subtractionCompleted {
                    VictoryView()
        } else {
            TabView {
                MathView(operation: .addition, isCompleted: $additionCompleted)
                    .tabItem {
                        Label("Addition", systemImage: "plus")
                    }
                MathView(operation: .subtraction, isCompleted: $subtractionCompleted)
                    .tabItem {
                        Label("Subtraktion", systemImage: "minus")
                    }
                MathView(operation: .multiplication, isCompleted: $multiplicationCompleted)
                    .tabItem {
                        Label("Multiplikation", systemImage: "multiply")
                    }
                MathView(operation: .division, isCompleted: $divisionCompleted)
                    .tabItem {
                        Label("Division", systemImage: "divide")
                    }
            }
        }
    }
}

enum MathOperation {
    case addition, subtraction, multiplication, division
}

class MathProblem: Identifiable, Observable {
    let id = UUID()
    let left: Int
    let right: Int
    let operation: MathOperation
    var userAnswer: String = "" {
        didSet {
            updateBorderColor()
        }
    }
    
    var correctAnswer: Int {
        switch operation {
        case .addition: return left + right
        case .subtraction: return left - right
        case .multiplication: return left * right
        case .division: return right != 0 ? left / right : 1
        }
    }
    
   @Published var borderColor: Color = .gray
    
    init(left: Int, right: Int, operation: MathOperation) {
        self.left = left
        self.right = right
        self.operation = operation
    }
    
    func updateBorderColor() {
        guard let answer = Int(userAnswer) else {
            borderColor = .gray
            return
        }
        borderColor = answer == correctAnswer ? .green : .red
    }
}

struct VictoryView: View {
    var body: some View {
        ZStack {
            FallingCoinsView()
            
            Text("Du vann 80 Robux!")
                .font(.system(size: 100, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}


struct FallingCoinsView: View {
    @State private var coins: [Coin] = []
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all) // Tło dla efektu końca gry
            
            ForEach(coins) { coin in
                Image("coin")
                    .resizable()
                    .frame(width: coin.size, height: coin.size)
                    .rotationEffect(.degrees(coin.rotation))
                    .position(x: coin.x, y: coin.y)
                    .onAppear {
                        animateCoinDrop(coin)
                    }
            }
        }
        .onAppear {
            startCoinRain()
            playCoinSound() // Odtwarzanie dźwięku
        }
        .onDisappear {
            stopCoinRain()
        }
    }

    func startCoinRain() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            let newCoin = Coin(
                id: UUID(),
                x: CGFloat.random(in: 0...screenWidth),
                y: -50, // Start poza ekranem
                size: CGFloat.random(in: 30...200), // Losowy rozmiar
                rotation: Double.random(in: 0...360), // Losowa rotacja
                duration: Double.random(in: 0.5...2) // Różne prędkości spadania
            )
            coins.append(newCoin)
        }
    }

    func animateCoinDrop(_ coin: Coin) {
        if let index = coins.firstIndex(where: { $0.id == coin.id }) {
            withAnimation(.linear(duration: coin.duration)) {
                coins[index].y = screenHeight + 50 // Moneta spada poza ekran
            }

            // Usunięcie monety po animacji
            DispatchQueue.main.asyncAfter(deadline: .now() + coin.duration) {
                coins.removeAll { $0.id == coin.id }
            }
        }
    }

    func stopCoinRain() {
        timer?.invalidate()
        timer = nil
    }

    func playCoinSound() {
        guard let soundURL = Bundle.main.url(forResource: "coin_sound", withExtension: "mp3") else {
            print("Nie znaleziono pliku dźwiękowego.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1 // Zapętlenie dźwięku
            audioPlayer?.play()
        } catch {
            print("Błąd podczas odtwarzania dźwięku: \(error)")
        }
    }
}

struct Coin: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var rotation: Double
    var duration: Double
}



struct MathView: View {
    let operation: MathOperation
    @State private var problems: [MathProblem] = []
    @Binding var isCompleted: Bool
    
    @FocusState private var isActive: Bool
    
    init(operation: MathOperation, isCompleted: Binding<Bool>) {
        self.operation = operation
        self._isCompleted = isCompleted
        _problems = State(initialValue: MathView.generateProblems(for: operation))
    }
    
    static func generateProblems(for operation: MathOperation) -> [MathProblem] {
        var problems = [MathProblem]()
        for _ in 0..<60 {
            var left = 1
            var right = 1
            
            switch operation {
            case .multiplication:
                repeat {
                    left = Int.random(in: 1...10)
                    right = Int.random(in: 1...10)
                } while left * right > 100
            case .division:
                repeat {
                    right = Int.random(in: 1...10)
                    left = right * Int.random(in: 1...10)
                } while left / right <= 0
            case .subtraction:
                left = Int.random(in: 1...30)
                right = Int.random(in: 1...left)
            default:
                left = Int.random(in: 1...30)
                right = Int.random(in: 1...30)
            }
            
            problems.append(MathProblem(left: left, right: right, operation: operation))
        }
        return problems
    }
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(problems.indices, id: \..self) { index in
                        HStack {
                            Spacer()
                            Text("\(problems[index].left) \(symbol) \(problems[index].right) =")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            
                            
                            
                            CustomTextFieldWithKeyboard {
                                TextField("?", text: $problems[index].userAnswer)
                                    .onChange(of: problems[index].userAnswer) { _ in
                                            problems[index].updateBorderColor()
                                            checkCompletion()
                                        }
                            } keyboard: {
                                CustomKeyboardView(
                                    
                                    text: Binding(
                                        get: { problems[index].userAnswer },
                                        set: { newValue in
                                            problems[index].userAnswer = newValue
                                            problems[index].updateBorderColor()
                                            checkCompletion()
                                        }
                                    ),
                                    
                                    isActive: $isActive)
                            }

                            
                            

                            
                            .font(.system(size: 24, weight: .bold, design: .rounded))
//                            .keyboardType(.numberPad)
                            .frame(width: 60, height: 34)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(problems[index].borderColor.opacity(0.3))
                            .cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(problems[index].borderColor, lineWidth: 2))
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle(title)
        }
    
    var title: String {
        switch operation {
        case .addition: return "Addition"
        case .subtraction: return "Subtraction"
        case .multiplication: return "Multiplication"
        case .division: return "Division"
        }
    }
    
    var symbol: String {
        switch operation {
        case .addition: return "+"
        case .subtraction: return "-"
        case .multiplication: return "×"
        case .division: return "÷"
        }
    }
    
    private func checkCompletion() {
        if problems.allSatisfy({ Int($0.userAnswer) == $0.correctAnswer }) {
            isCompleted = true
        }
    }
}

#Preview {
    ContentView()
}


import SwiftUI

struct CustomTextFieldWithKeyboard<TextField: View, Keyboard: View>: UIViewControllerRepresentable {
    @ViewBuilder var textField: TextField
    @ViewBuilder var keyboard: Keyboard

    func makeUIViewController(context: Context) -> UIHostingController<TextField> {
        let controller = UIHostingController(rootView: textField)
        controller.view.backgroundColor = .clear

        DispatchQueue.main.async {
            if let textField = controller.view.allSubviews.first(where: { $0 is UITextField }) as? UITextField, textField.inputView == nil {
                let inputController = UIHostingController(rootView: keyboard)
                inputController.view.backgroundColor = .clear
                inputController.view.frame = .init(origin: .zero, size: inputController.view.intrinsicContentSize)
                textField.inputView = inputController.view
                textField.reloadInputViews()
            }
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIHostingController<TextField>, context: Context) {
        // Update logic if needed
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: UIHostingController<TextField>, context: Context) -> CGSize? {
        return uiViewController.view.intrinsicContentSize
    }
}


// Finding all subviews from the UIView controller
fileprivate extension UIView {
    var allSubviews: [UIView] {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
}



struct CustomKeyboardView: View {
    @Binding var text: String
    @FocusState.Binding var isActive: Bool
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 3), spacing: 15) {
            ForEach(1...9, id: \.self) { index in
                ButtonView("\(index)")
            }
            ButtonView("delete.backward.fill", isImage: true)
            ButtonView("0")
            ButtonView("checkmark.circle.fill", isImage: true)
        }
        .padding(15)
        .background(.background.shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 0, y: -5)))
    }
    
    @ViewBuilder
    func ButtonView(_ value: String, isImage: Bool = false) -> some View {
        Button {
            if isImage {
                if value == "" && !text.isEmpty {
                    /// Delete last character
                    text.removeLast()
                }

                if value == "checkmark.circle.fill" {
                    /// Close Keyboard
                    isActive = false
                }
            } else {
                print(value)
                text += value
            }
        } label: {
            Group {
                if isImage {
                    Image(systemName: value)
                } else {
                    Text(value)
                }
            }
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 50, height: 50)
            .background {
                if !isImage {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.background.shadow(.drop(color: .black.opacity(0.08), radius: 3, x: 0, y: 0)))
                }
            }
            .foregroundStyle(Color.primary)
        }
    }
}
