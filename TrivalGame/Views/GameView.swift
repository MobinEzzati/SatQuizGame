import SwiftUI

import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack {
                switch viewModel.gameState {
                case .notStarted:
                    startGameView
                        .transition(.scale.combined(with: .opacity))
                case .player1Turn, .player2Turn:
                    questionView
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                case .showingResults:
                    roundResultsView
                        .transition(.scale.combined(with: .opacity))
                case .gameOver:
                    gameOverView
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding()
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.gameState)
        }
        .overlay {
            if viewModel.isTransitioning {
                transitionOverlay
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.isTransitioning)
            }
        }
    }
}

#Preview {
    GameView()
}
// MARK: - Transition Overlay
extension GameView {
    private var transitionOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                FrogLogo(size: 80)
                    .scaleEffect(1.2)
                
                Text(viewModel.transitionMessage)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .multilineTextAlignment(.center)
                
                Text("Get Ready!")
                    .font(.title2)
                    .foregroundColor(.white)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }
    
    private var startGameView: some View {
        VStack(spacing: 30) {
            FrogLogo(size: 120)
            
            Text("SAT Math Trivia")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(
                    LinearGradient(colors: [.blue, .purple, .pink], startPoint: .leading, endPoint: .trailing)
                )
            
            Text("Test your math skills!")
                .font(.title3)
                .foregroundColor(.secondary)
            
            VStack(spacing: 20) {
                GameTextField(title: "Player 1 Name", text: $viewModel.player1Name, placeholder: "Enter name")
                GameTextField(title: "Player 2 Name", text: $viewModel.player2Name, placeholder: "Enter name")
            }
            
            GameButton(title: "Start Game", action: viewModel.startGame, isEnabled: viewModel.canStartGame)
        }
        .padding()
    }
    
    private var questionView: some View {
        VStack(spacing: 25) {
            HStack {
                Text("Round \(viewModel.currentRound)")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                
                Spacer()
                
                if !viewModel.shouldHidePreviousPlayerTime || viewModel.gameState == .player1Turn {
                    Text(viewModel.formattedTime)
                        .font(.title2)
                        .monospacedDigit()
                        .foregroundStyle(LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing))
                }
            }
            
            Text("\(viewModel.currentPlayer?.name ?? "")'s Turn")
                .font(.title3)
                .foregroundColor(.secondary)
            
            if let question = viewModel.currentQuestion {
                VStack(alignment: .leading, spacing: 20) {
                    Text(question.text)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    
                    VStack(spacing: 12) {
                        ForEach(question.options, id: \.self) { option in
                            GameButton(title: option, action: { viewModel.submitAnswer(option) })
                        }
                    }
                }
            }
        }
    }
    
    private var roundResultsView: some View {
        VStack(spacing: 25) {
            Text("Round \(viewModel.currentRound) Results")
                .font(.title)
                .bold()
                .foregroundStyle(LinearGradient(colors: [.blue, .purple, .pink], startPoint: .leading, endPoint: .trailing))
            
            if let lastResult = viewModel.roundResults.last {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Question:").font(.headline)
                    Text(lastResult.question.text).font(.body).padding()
                    
                    Text("\(lastResult.winner?.name ?? "Tie") wins the round!")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing))
                        .padding(.top)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
            }
            
            if !viewModel.isGameOver {
                GameButton(title: "Next Round", action: { viewModel.startNewRound() })
            }
        }
    }
    
    private var gameOverView: some View {
        VStack(spacing: 30) {
            FrogLogo(size: 120)
            
            Text("Game Over!")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(LinearGradient(colors: [.blue, .purple, .pink], startPoint: .leading, endPoint: .trailing))
            
            if let winner = viewModel.gameWinner {
                Text("\(winner.name) Wins!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(LinearGradient(colors: [.green, .blue], startPoint: .leading, endPoint: .trailing))
                
                Text("First to win 3 rounds!").font(.headline).foregroundColor(.secondary)
            }
            
            VStack(spacing: 20) {
                Text("Final Score").font(.title2).bold()
                
                HStack(spacing: 40) {
                    VStack {
                        Text("\(viewModel.player1Name)").font(.headline)
                        Text("\(viewModel.player1Score)").font(.title)
                    }
                    
                    VStack {
                        Text("\(viewModel.player2Name)").font(.headline)
                        Text("\(viewModel.player2Score)").font(.title)
                    }
                }
            }
            .padding()
            
            GameButton(title: "Play Again", action: viewModel.startGame)
        }
    }
}





