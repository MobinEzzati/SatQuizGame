import SwiftUI

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    struct Bubble: Identifiable {
        let id = UUID()
        var position: CGPoint
        var size: CGFloat
        var speed: CGFloat
        var color: Color
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base gradient
                LinearGradient(
                    colors: [
                        .mint.opacity(0.2),
                        .blue.opacity(0.1),
                        .purple.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Animated bubbles
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(bubble.color)
                        .frame(width: bubble.size, height: bubble.size)
                        .position(bubble.position)
                        .opacity(0.3)
                        .blur(radius: 2)
                }
            }
            .onAppear {
                createBubbles(in: geometry.size)
            }
            .onReceive(timer) { _ in
                updateBubbles(in: geometry.size)
            }
        }
    }
    
    private func createBubbles(in size: CGSize) {
        bubbles = (0..<10).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                size: CGFloat.random(in: 50...150),
                speed: CGFloat.random(in: 1...3),
                color: [.blue, .purple, .pink, .mint, .green].randomElement() ?? .blue
            )
        }
    }
    
    private func updateBubbles(in size: CGSize) {
        bubbles = bubbles.map { bubble in
            var newBubble = bubble
            newBubble.position.y -= bubble.speed
            
            // Reset bubble position when it goes off screen
            if newBubble.position.y < -bubble.size {
                newBubble.position = CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: size.height + bubble.size
                )
            }
            
            return newBubble
        }
    }
} 

#Preview {
    AnimatedBackground()
}
