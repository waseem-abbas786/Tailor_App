import SwiftUI
struct ModernTextFieldModifier: ViewModifier {
    var icon: String?
    @FocusState private var isFocused: Bool

    func body(content: Content) -> some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(isFocused ? .blue : .gray)
                    .frame(width: 22)
            }

            content
                .focused($isFocused)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray6))
                .shadow(color: isFocused ? .blue.opacity(0.2) : .black.opacity(0.05),
                        radius: 5, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .padding(.horizontal)
    }
}

extension View {
    func modernTextFieldStyle(icon: String? = nil) -> some View {
        self.modifier(ModernTextFieldModifier(icon: icon))
    }
}
