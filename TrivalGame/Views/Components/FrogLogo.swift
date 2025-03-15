import SwiftUI

struct FrogLogo: View {
    var size: CGFloat = 100
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Body
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            // Eyes
            HStack(spacing: size * 0.3) {
                Circle()
                    .fill(.white)
                    .frame(width: size * 0.3, height: size * 0.3)
                    .overlay(
                        Circle()
                            .fill(.black)
                            .frame(width: size * 0.15, height: size * 0.15)
                            .offset(x: isAnimating ? 2 : -2, y: isAnimating ? -2 : 2)
                    )
                
                Circle()
                    .fill(.white)
                    .frame(width: size * 0.3, height: size * 0.3)
                    .overlay(
                        Circle()
                            .fill(.black)
                            .frame(width: size * 0.15, height: size * 0.15)
                            .offset(x: isAnimating ? -2 : 2, y: isAnimating ? 2 : -2)
                    )
            }
            .animation(
                Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                value: isAnimating
            )
            
            // Smile
            Arc(startAngle: .degrees(0), endAngle: .degrees(180))
                .stroke(Color.black, lineWidth: size * 0.05)
                .frame(width: size * 0.6, height: size * 0.3)
                .offset(y: size * 0.1)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            // Cheeks
            HStack(spacing: size * 0.8) {
                Circle()
                    .fill(.pink.opacity(0.3))
                    .frame(width: size * 0.2, height: size * 0.2)
                    .blur(radius: 2)
                
                Circle()
                    .fill(.pink.opacity(0.3))
                    .frame(width: size * 0.2, height: size * 0.2)
                    .blur(radius: 2)
            }
            .offset(y: size * 0.15)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct Arc: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return path
    }
} 