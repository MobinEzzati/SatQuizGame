import Foundation

struct Player: Identifiable, Codable {
    let id: UUID
    let name: String
    var score: Int
    var roundWins: Int
    var totalTime: TimeInterval
    var answers: [PlayerAnswer]
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.score = 0
        self.roundWins = 0
        self.totalTime = 0
        self.answers = []
    }
}

struct PlayerAnswer: Codable {
    let questionId: UUID
    let answer: String
    let timeTaken: TimeInterval
    let isCorrect: Bool
    let timestamp: Date
} 