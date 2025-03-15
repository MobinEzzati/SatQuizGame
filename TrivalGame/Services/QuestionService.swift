import Foundation

class QuestionService {
    static let shared = QuestionService()
    
    private let questions: [Question] = [
        Question(
            text: "What is the value of x in the equation 2x + 5 = 13?",
            options: ["3", "4", "5", "6"],
            correctAnswer: "4",
            explanation: "Subtract 5 from both sides: 2x = 8, then divide by 2: x = 4",
            difficulty: .easy
        ),
        Question(
            text: "If a triangle has angles measuring 45°, 45°, and 90°, what is the ratio of its sides?",
            options: ["1:1:√2", "1:2:3", "2:2:3", "3:4:5"],
            correctAnswer: "1:1:√2",
            explanation: "This is a 45-45-90 triangle, where the sides are in the ratio 1:1:√2",
            difficulty: .medium
        ),
        Question(
            text: "What is the slope of the line perpendicular to y = 2x + 3?",
            options: ["-2", "-1/2", "1/2", "2"],
            correctAnswer: "-1/2",
            explanation: "The slope of a perpendicular line is the negative reciprocal of the original line's slope",
            difficulty: .medium
        ),
        Question(
            text: "If f(x) = x² + 2x + 1, what is f(3)?",
            options: ["10", "12", "14", "16"],
            correctAnswer: "16",
            explanation: "Substitute x = 3: f(3) = 3² + 2(3) + 1 = 9 + 6 + 1 = 16",
            difficulty: .easy
        ),
        Question(
            text: "What is the area of a circle with radius 4?",
            options: ["8π", "12π", "16π", "20π"],
            correctAnswer: "16π",
            explanation: "Area = πr² = π(4)² = 16π",
            difficulty: .easy
        ),
        Question(
            text: "Solve the quadratic equation x² - 4x + 4 = 0",
            options: ["x = 2", "x = -2", "x = 2 or -2", "No solution"],
            correctAnswer: "x = 2",
            explanation: "This is a perfect square: (x - 2)² = 0, so x = 2",
            difficulty: .medium
        ),
        Question(
            text: "What is the probability of rolling a sum of 7 with two dice?",
            options: ["1/6", "1/8", "1/9", "1/12"],
            correctAnswer: "1/6",
            explanation: "There are 6 ways to roll a 7 out of 36 possible outcomes",
            difficulty: .hard
        ),
        Question(
            text: "If sin(θ) = 0.5, what is cos(θ)?",
            options: ["0.5", "0.707", "0.866", "1"],
            correctAnswer: "0.866",
            explanation: "For θ = 30°, sin(θ) = 0.5 and cos(θ) = √3/2 ≈ 0.866",
            difficulty: .hard
        ),
        Question(
            text: "What is the volume of a cube with surface area 54?",
            options: ["9", "18", "27", "36"],
            correctAnswer: "27",
            explanation: "Surface area = 6s² = 54, so s = 3. Volume = s³ = 27",
            difficulty: .medium
        ),
        Question(
            text: "If log₂(x) = 3, what is x?",
            options: ["4", "6", "8", "10"],
            correctAnswer: "8",
            explanation: "log₂(x) = 3 means 2³ = x, so x = 8",
            difficulty: .medium
        )
    ]
    
    func getRandomQuestion() -> Question {
        questions.randomElement()!
    }
    
    func getQuestionsByDifficulty(_ difficulty: Question.Difficulty) -> [Question] {
        questions.filter { $0.difficulty == difficulty }
    }
} 