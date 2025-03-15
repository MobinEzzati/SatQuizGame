import Foundation

struct Question: Identifiable, Codable {
    let id: UUID
    let text: String
    let options: [String]
    let correctAnswer: String
    let explanation: String
    let difficulty: Difficulty
    
    enum Difficulty: String, Codable {
        case easy
        case medium
        case hard
    }
    
    init(text: String, options: [String], correctAnswer: String, explanation: String, difficulty: Difficulty) {
        self.id = UUID()
        self.text = text
        self.options = options
        self.correctAnswer = correctAnswer
        self.explanation = explanation
        self.difficulty = difficulty
    }
} 