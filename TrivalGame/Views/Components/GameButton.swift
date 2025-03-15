import SwiftUI

struct GameButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var style: GameButtonStyle = .primary
    
    enum GameButtonStyle {
        case primary
        case secondary
        case destructive
        
        var gradient: LinearGradient {
            switch self {
            case .primary:
                return LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .secondary:
                return LinearGradient(
                    colors: [.gray, .secondary],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .destructive:
                return LinearGradient(
                    colors: [.red, .orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        
        var shadowColor: Color {
            switch self {
            case .primary: return .blue
            case .secondary: return .gray
            case .destructive: return .red
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(style.gradient)
                        .shadow(color: style.shadowColor.opacity(0.3), radius: 5, x: 0, y: 3)
                )
                .opacity(isEnabled ? 1 : 0.5)
        }
        .disabled(!isEnabled)
    }
} 