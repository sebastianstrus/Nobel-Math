//
//  ContentView.swift
//  Matematik2
//
//  Created by Sebastian Strus on 2025-02-04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MathView(operation: .addition)
                .tabItem {
                    Label("Addition", systemImage: "plus")
                }
            MathView(operation: .subtraction)
                .tabItem {
                    Label("Subtraction", systemImage: "minus")
                }
            MathView(operation: .multiplication)
                .tabItem {
                    Label("Multiplication", systemImage: "multiply")
                }
            MathView(operation: .division)
                .tabItem {
                    Label("Division", systemImage: "divide")
                }
        }
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
    
    var borderColor: Color = .gray
    
    mutating func updateBorderColor() {
        guard let answer = Int(userAnswer) else {
            borderColor = .gray
            return
        }
        borderColor = answer == correctAnswer ? .green : .red
    }
}

struct MathView: View {
    let operation: MathOperation
    @State private var problems: [MathProblem] = []
    
    init(operation: MathOperation) {
        self.operation = operation
        _problems = State(initialValue: MathView.generateProblems(for: operation))
    }
    
    static func generateProblems(for operation: MathOperation) -> [MathProblem] {
        var problems = [MathProblem]()
        for _ in 0..<30 {
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
                left = Int.random(in: 1...20)
                right = Int.random(in: 1...left)
            default:
                left = Int.random(in: 1...20)
                right = Int.random(in: 1...20)
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
                            Text("\(problems[index].left) \(symbol) \(problems[index].right) =")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            TextField("?", text: Binding(
                                get: { problems[index].userAnswer },
                                set: { newValue in
                                    problems[index].userAnswer = newValue
                                    problems[index].updateBorderColor()
                                }
                            ))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .keyboardType(.numberPad)
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
}

#Preview {
    ContentView()
}
