//
//  ContentView.swift
//  Matematik2
//
//  Created by Sebastian Strus on 2025-02-04.
//

import SwiftUI
import AVFoundation
import MediaPlayer

struct LearnView: View {
    @EnvironmentObject var settings: SettingsManager
    @Environment(\.dismiss) var dismiss
    
    // Timer related state variables
    @State private var startTime: Date?
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
    // Completion tracking
    @State private var additionCompleted = false
    @State private var subtractionCompleted = false
    @State private var multiplicationCompleted = false
    @State private var divisionCompleted = false
    
    @State private var additionHasProgress = false
    @State private var subtractionHasProgress = false
    @State private var multiplicationHasProgress = false
    @State private var divisionHasProgress = false
    
    // UI state
    @State private var showBackConfirmation = false
    @State private var shouldShowNameAlert = false
    @State private var showingVictoryView = false
    @State private var userName = ""
    
    init() {
        //setMaxVolume()
        //setMaxBrightness()
    }
    
    var body: some View {
        ZStack {
            // Main content
            if showingVictoryView || shouldShowVoctoryView() {
                VictoryView(elapsedTime: elapsedTime)
                    .environmentObject(settings)
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            Button {
//                                dismiss()
//                            } label: {
//                                HStack {
//                                    Image(systemName: "chevron.left")
//                                    Text("Back".localized)
//                                }
//                                .foregroundColor(.blue)
//                            }
//                        }
//                    }
            } else {
                TabView {
                    if settings.isAdditionOn {
                        MathView(operation: .addition,
                                isCompleted: $additionCompleted,
                                hasProgress: $additionHasProgress,
                                settings: settings)
                            .tabItem { Label("Addition".localized, systemImage: "plus") }
                    }
                    
                    if settings.isSubtractionOn {
                        MathView(operation: .subtraction,
                                isCompleted: $subtractionCompleted,
                                hasProgress: $subtractionHasProgress,
                                settings: settings)
                            .tabItem { Label("Subtraction".localized, systemImage: "minus") }
                    }
                    
                    if settings.isMultiplicationOn {
                        MathView(operation: .multiplication,
                                isCompleted: $multiplicationCompleted,
                                hasProgress: $multiplicationHasProgress,
                                settings: settings)
                            .tabItem { Label("Multiplication".localized, systemImage: "multiply") }
                    }
                    
                    if settings.isDivisionOn {
                        MathView(operation: .division,
                                isCompleted: $divisionCompleted,
                                hasProgress: $divisionHasProgress,
                                settings: settings)
                            .tabItem { Label("Division".localized, systemImage: "divide") }
                    }
                }
                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button {
//                            let hasProgress = additionHasProgress || subtractionHasProgress ||
//                            multiplicationHasProgress || divisionHasProgress
//                            
//                            if hasProgress {
//                                showBackConfirmation = true
//                            } else {
//                                dismiss()
//                            }
//                        } label: {
//                            HStack {
//                                Image(systemName: "chevron.left")
//                                Text("Back".localized)
//                            }
//                            .foregroundColor(.blue)
//                        }
//                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text(formattedTime(elapsedTime))
                            .font(.system(size: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16,
                                        weight: .bold,
                                        design: .monospaced))
                            .foregroundColor(.blue.opacity(settings.isTimerOn ? 1 : 0))

                    }
                }
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .alert("Congratulations!".localized + "\n" + elapsedTime.formatedTime, isPresented: $shouldShowNameAlert) {
            TextField("Nickname".localized, text: $userName)
            Button("Save".localized) {
                saveResultAndShowVictory()
            }
            Button("Skip".localized, role: .cancel) {
                showingVictoryView = true
            }
        } message: {
            Text("Enter your nickname to save the result".localized)
        }
        .onChange(of: shouldShowVoctoryView()) { completed in
            if completed {
                stopTimer()
                showingVictoryView = true
                
                // Only show the name alert if ALL operations are enabled
                let allOperationsEnabled =
                    settings.isAdditionOn &&
                    settings.isSubtractionOn &&
                    settings.isMultiplicationOn &&
                    settings.isDivisionOn
                
                if allOperationsEnabled {
                    shouldShowNameAlert = true
                }
            }
        }
        .alert(isPresented: $showBackConfirmation) {
            Alert(
                title: Text("Are you sure?".localized),
                message: Text("Your progress will be lost if you go back.".localized),
                primaryButton: .destructive(Text("Discard Changes".localized)) {
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func saveResultAndShowVictory() {
        let difficulty = DifficultyLevel(rawValue: settings.difficultyLevel) ?? .medium
        settings.saveGameResult(
            name: userName.isEmpty ? "Anonymous" : userName,
            difficulty: difficulty,
            exampleCount: settings.exampleCount,
            time: elapsedTime
        )
    }
    
    private func startTimer() {
        guard startTime == nil else { return }
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let startTime = startTime {
                elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    func shouldShowVoctoryView() -> Bool {
        let tabsEnabledCount: Int = [settings.isAdditionOn,
                                   settings.isSubtractionOn,
                                   settings.isMultiplicationOn,
                                   settings.isDivisionOn].filter { $0 }.count
        
        let tabsCompletedCount: Int = [additionCompleted,
                                     subtractionCompleted,
                                     multiplicationCompleted,
                                     divisionCompleted].filter { $0 }.count
        
        return tabsEnabledCount == tabsCompletedCount
    }
    
    func setMaxVolume() {
        let volumeView = MPVolumeView()
        if let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                slider.value = 1.0
            }
        }
    }
    
    func setMaxBrightness() {
        UIScreen.main.brightness = 1.0
    }
}


enum MathOperation {
    case addition, subtraction, multiplication, division
}

struct MathProblem: Identifiable {
    let id = UUID()
    let left: Int
    let right: Int
    let operation: MathOperation
    var userAnswer: String = ""
    
    var correctAnswer: Int {
        switch operation {
        case .addition: return left + right
        case .subtraction: return left - right
        case .multiplication: return left * right
        case .division: return right != 0 ? left / right : 1
        }
    }
    
    var borderColor: Color = .gray
    
    /*mutating func updateBorderColor() {
        guard let answer = Int(userAnswer.replacingOccurrences(of: " ", with: "")) else {
            borderColor = .gray
            return
        }
        borderColor = answer == correctAnswer ? .green : .red
    }*/
}

struct VictoryView: View {
    @EnvironmentObject var settings: SettingsManager
    let elapsedTime: TimeInterval
    let fontSize: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 50 : 25
    }()
    
//    private func formattedTime(_ time: TimeInterval) -> String {
//        let minutes = Int(time) / 60
//        let seconds = Int(time) % 60
//        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
//        
//        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
//    }
    
    
    
    var body: some View {
        
        let allOperationsEnabled =
            settings.isAdditionOn &&
            settings.isSubtractionOn &&
            settings.isMultiplicationOn &&
            settings.isDivisionOn
        
        ZStack {
            FallingCoinsView()
            
            if !allOperationsEnabled {
                VStack {
                    Text("Congratulations!\nYou won!".localized)
                        .font(.system(size: fontSize, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    Text("Time:".localized)
                        .font(.system(size: fontSize * 0.7, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(elapsedTime.formatedTime)

                        .font(.system(size: fontSize * 0.7, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }
            }
           
        }
    }
}




struct MathView: View {
    
    let hintFontSize: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 22 : 12
    }()
    
    let lineWidth: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 10 : 5
    }()
    
    let fieldWidth: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 60 : 30
    }()
    
    let fieldHeight: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 34 : 20
    }()
    
    let spacing: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 14 : 12
    }()
    
    let cornerRadius: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 5 : 3
    }()
    
    let fieldLineWidth: CGFloat = {
        UIDevice.current.userInterfaceIdiom == .pad ? 2 : 1
    }()
    
    var settings: SettingsManager
    let operation: MathOperation
    @State private var problems: [MathProblem] = []
    @Binding var isCompleted: Bool
    @Binding var hasProgress: Bool
    
    init(operation: MathOperation, isCompleted: Binding<Bool>, hasProgress: Binding<Bool>, settings: SettingsManager) {
        self.operation = operation
        self._isCompleted = isCompleted
        self._hasProgress = hasProgress
        self.settings = settings
        _problems = State(initialValue: generateProblems(for: operation))
    }
    
    
    var body: some View {
        VStack {
            Text("").frame(height: 0)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: spacing) {
                    ForEach(problems.indices, id: \..self) { index in
                        HStack {
                            Spacer(minLength: 0)
                            Text("\(problems[index].left) \(symbol) \(problems[index].right) =")
                                .font(.system(size: hintFontSize, weight: .bold, design: .rounded))
                            TextField("?", text: Binding(
                                get: { problems[index].userAnswer },
                                set: { newValue in
                                    problems[index].userAnswer = newValue
                                    updateBorderColors()
                                    checkCompletion()
                                    checkProgress()
                                }
                            ))
                            .font(.system(size: hintFontSize, weight: .bold, design: .rounded))
                            .keyboardType(.numberPad)
                            .frame(width: fieldWidth, height: fieldHeight)
                            .multilineTextAlignment(.center)
                            .padding(UIDevice.current.userInterfaceIdiom == .pad ? 16 : 4)
                            .background(problems[index].borderColor.opacity(0.3))
                            .cornerRadius(cornerRadius)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(problems[index].borderColor, lineWidth: fieldLineWidth))
                        }
                        .padding(UIDevice.current.userInterfaceIdiom == .pad ? 16 : 4)
//                        .overlay {
//                            Rectangle()
//                                .stroke(Color.red, lineWidth: 1)
//                        }
                    }
                }
                .padding(.trailing, UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12)
            }
            .navigationTitle(title)
        }.padding(.trailing, UIScreen.main.bounds.width > 1000 ? 60 : 0)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func updateBorderColors() {
        for i in stride(from: 0, to: problems.count, by: 3) {
            if i + 2 < problems.count {
                let allCorrect = (0...2).allSatisfy { offset in
                    let index = i + offset
                    return Int(problems[index].userAnswer.replacingOccurrences(of: " ", with: "")) == problems[index].correctAnswer
                }
                
                for offset in 0...2 {
                    let index = i + offset
                    problems[index].borderColor = allCorrect ? .green : .gray
                }
            }
        }
    }
    
    func generateProblems(for operation: MathOperation) -> [MathProblem] {
        let count: Int = settings.exampleCount
        var problems = [MathProblem]()
        for _ in 0..<count {
            var left = 1
            var right = 1
            
            switch operation {
            case .addition:
                switch settings.difficultyLevel {
                case 0:
                    left = Int.random(in: 1...10)
                    right = Int.random(in: 1...10)
                case 1:
                    left = Int.random(in: 1...20)
                    right = Int.random(in: 1...20)
                default:
                    left = Int.random(in: 9...50)
                    right = Int.random(in: 9...50)
                }
            case .subtraction:
                switch settings.difficultyLevel {
                case 0:
                    left = Int.random(in: 2...20)
                    right = Int.random(in: 1...left-1)
                case 1:
                    left = Int.random(in: 2...49)
                    right = Int.random(in: 1...left-1)
                default:
                    left = Int.random(in: 10...99)
                    right = Int.random(in: 9...left-1)
                }
                
            case .multiplication:
                repeat {
                    switch settings.difficultyLevel {
                    case 0:
                        left = Int.random(in: 1...6)
                        right = Int.random(in: 1...6)
                    case 1:
                        left = Int.random(in: 1...10)
                        right = Int.random(in: 1...10)
                    default:
                        left = Int.random(in: 2...50)
                        right = Int.random(in: 2...50)
                    }
                } while left * right > 100
            case .division:
                repeat {
                    switch settings.difficultyLevel {
                    case 0:
                        right = Int.random(in: 1...5)
                        left = right * Int.random(in: 1...5)
                    case 1:
                        right = Int.random(in: 1...6)
                        left = right * Int.random(in: 1...6)
                    default:
                        right = Int.random(in: 2...10)
                        left = right * Int.random(in: 2...9)
                    }
                } while left / right <= 0
            }
            
            problems.append(MathProblem(left: left, right: right, operation: operation))
        }
        
        return problems
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
        if problems.allSatisfy({ Int($0.userAnswer.replacingOccurrences(of: " ", with: "")) == $0.correctAnswer }) {
            isCompleted = true
        } else {
            isCompleted = false
        }
    }
    
    private func checkProgress() {
        if problems.contains(where: { Int($0.userAnswer.replacingOccurrences(of: " ", with: "")) == $0.correctAnswer }) {
            hasProgress = true
        } else {
            hasProgress = false
        }
    }
}

