//
//  Keyboard.swift
//  Matematik
//
//  Created by Sebastian Strus on 2025-03-01.
//
//
//import SwiftUI
//
//struct CustomTextFieldWithKeyboard<TextField: View, Keyboard: View>: UIViewControllerRepresentable {
//    @ViewBuilder var textField: TextField
//    @ViewBuilder var keyboard: Keyboard
//
//    func makeUIViewController(context: Context) -> UIHostingController<TextField> {
//        let controller = UIHostingController(rootView: textField)
//        controller.view.backgroundColor = .clear
//
//        DispatchQueue.main.async {
//            if let textField = controller.view.allSubviews.first(where: { $0 is UITextField }) as? UITextField, textField.inputView == nil {
//                let inputController = UIHostingController(rootView: keyboard)
//                inputController.view.backgroundColor = .clear
//                inputController.view.frame = .init(origin: .zero, size: inputController.view.intrinsicContentSize)
//                textField.inputView = inputController.view
//                textField.reloadInputViews()
//            }
//        }
//
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIHostingController<TextField>, context: Context) {
//        // Update logic if needed
//    }
//
//    func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: UIHostingController<TextField>, context: Context) -> CGSize? {
//        return uiViewController.view.intrinsicContentSize
//    }
//}
//
//
//// Finding all subviews from the UIView controller
//fileprivate extension UIView {
//    var allSubviews: [UIView] {
//        return self.subviews.flatMap { [$0] + $0.allSubviews }
//    }
//}
//
//
//
//struct CustomKeyboardView: View {
//    @Binding var text: String
//    @FocusState.Binding var isActive: Bool
//    
//    var body: some View {
//        LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 3), spacing: 15) {
//            ForEach(1...9, id: \.self) { index in
//                ButtonView("\(index)")
//            }
//            ButtonView("delete.backward.fill", isImage: true)
//            ButtonView("0")
//            ButtonView("checkmark.circle.fill", isImage: true)
//        }
//        .padding(15)
//        .background(.background.shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 0, y: -5)))
//    }
//    
//    @ViewBuilder
//    func ButtonView(_ value: String, isImage: Bool = false) -> some View {
//        Button {
//            if isImage {
//                if value == "" && !text.isEmpty {
//                    /// Delete last character
//                    text.removeLast()
//                }
//
//                if value == "checkmark.circle.fill" {
//                    /// Close Keyboard
//                    isActive = false
//                }
//            } else {
//                print(value)
//                text += value
//            }
//        } label: {
//            Group {
//                if isImage {
//                    Image(systemName: value)
//                } else {
//                    Text(value)
//                }
//            }
//            .font(.title3)
//            .fontWeight(.semibold)
//            .frame(width: 50, height: 50)
//            .background {
//                if !isImage {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(.background.shadow(.drop(color: .black.opacity(0.08), radius: 3, x: 0, y: 0)))
//                }
//            }
//            .foregroundStyle(Color.primary)
//        }
//    }
//}
