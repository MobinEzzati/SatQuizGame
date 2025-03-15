import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var currentRound: Int = 1
    @Published var currentQuestion: Question?
    @Published var currentPlayer: Player?
    @Published var gameState: GameState = .notStarted
    @Published var roundResults: [RoundResult] = []
    @Published var currentTime: TimeInterval = 0
    @Published var isTransitioning: Bool = false
    @Published var player1Name: String = ""
    @Published var player2Name: String = ""
    @Published var shouldHidePreviousPlayerTime: Bool = true
    @Published var transitionMessage: String = ""
    
     var player1: Player
     var player2: Player
    private var timer: Timer?
    private var startTime: Date?
    
    enum GameState {
        case notStarted
        case player1Turn
        case player2Turn
        case showingResults
        case gameOver
    }
    
    struct RoundResult: Identifiable {
        let id = UUID()
        let roundNumber: Int
        let question: Question
        let player1Answer: PlayerAnswer
        let player2Answer: PlayerAnswer
        let winner: Player?
    }
    
    init() {
        self.player1 = Player(name: "Player 1")
        self.player2 = Player(name: "Player 2")
    }
    
    var canStartGame: Bool {
        !player1Name.isEmpty && !player2Name.isEmpty
    }
    
    var formattedTime: String {
        String(format: "%.1f", currentTime)
    }
    
    var player1Score: Int {
        roundResults.filter { $0.winner?.id == player1.id }.count
    }
    
    var player2Score: Int {
        roundResults.filter { $0.winner?.id == player2.id }.count
    }
    
    func startGame() {
        reset()
        player1 = Player(name: player1Name)
        player2 = Player(name: player2Name)
        gameState = .player1Turn
        currentPlayer = player1
        startNewRound()
    }
    
    private func reset() {
        currentRound = 1
        currentQuestion = nil
        currentPlayer = nil
        gameState = .notStarted
        roundResults = []
        stopTimer()
        startTime = nil
        currentTime = 0
        isTransitioning = false
        shouldHidePreviousPlayerTime = true
        transitionMessage = ""
    }
    
    func startNewRound() {
        if player1.roundWins < 3 && player2.roundWins < 3 {
            isTransitioning = true
            shouldHidePreviousPlayerTime = true
            transitionMessage = "\(player1.name)'s Turn"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else { return }
                self.isTransitioning = false
                self.gameState = .player1Turn
                self.currentPlayer = self.player1
                self.currentQuestion = QuestionService.shared.getRandomQuestion()
                self.startTimer()
            }
        }
    }
    
    func submitAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        
        let timeTaken = Date().timeIntervalSince(startTime ?? Date())
        let isCorrect = answer == question.correctAnswer
        
        let playerAnswer = PlayerAnswer(
            questionId: question.id,
            answer: answer,
            timeTaken: timeTaken,
            isCorrect: isCorrect,
            timestamp: Date()
        )
        
        if currentPlayer?.id == player1.id {
            player1.answers.append(playerAnswer)
            player1.totalTime += timeTaken
            if isCorrect {
                player1.score += 1
            }
        } else {
            player2.answers.append(playerAnswer)
            player2.totalTime += timeTaken
            if isCorrect {
                player2.score += 1
            }
        }
        
        stopTimer()
        
        if gameState == .player1Turn {
            transitionToPlayer2()
        } else {
            determineRoundWinner()
        }
    }
    
    private func transitionToPlayer2() {
        isTransitioning = true
        shouldHidePreviousPlayerTime = true
        transitionMessage = "\(player2.name)'s Turn"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.gameState = .player2Turn
            self.currentPlayer = self.player2
            self.isTransitioning = false
            self.startTimer()
        }
    }
    
    private func determineRoundWinner() {
        shouldHidePreviousPlayerTime = false
        guard let question = currentQuestion,
              let player1Answer = player1.answers.last,
              let player2Answer = player2.answers.last else { return }
        
        let winner: Player?
        
        if player1Answer.isCorrect && !player2Answer.isCorrect {
            winner = player1
            player1.roundWins += 1
        } else if !player1Answer.isCorrect && player2Answer.isCorrect {
            winner = player2
            player2.roundWins += 1
        } else if player1Answer.isCorrect && player2Answer.isCorrect {
            winner = player1Answer.timeTaken < player2Answer.timeTaken ? player1 : player2
            if winner?.id == player1.id {
                player1.roundWins += 1
            } else {
                player2.roundWins += 1
            }
        } else {
            winner = nil
        }
        
        let roundResult = RoundResult(
            roundNumber: currentRound,
            question: question,
            player1Answer: player1Answer,
            player2Answer: player2Answer,
            winner: winner
        )
        
        roundResults.append(roundResult)
        gameState = .showingResults
        
        if player1.roundWins >= 3 || player2.roundWins >= 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.gameState = .gameOver
            }
        } else {
            currentRound += 1
        }
    }
    
    private func startTimer() {
        startTime = Date()
        currentTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.currentTime = Date().timeIntervalSince(startTime)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var gameWinner: Player? {
        if player1.roundWins >= 3 {
            return player1
        } else if player2.roundWins >= 3 {
            return player2
        }
        return nil
    }
    
    var roundWinner: Player? {
        roundResults.last?.winner
    }
    
    var isGameOver: Bool {
        player1.roundWins >= 3 || player2.roundWins >= 3
    }
} 
