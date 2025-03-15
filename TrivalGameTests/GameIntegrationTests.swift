import XCTest
@testable import TrivalGame

final class GameIntegrationTests: XCTestCase {
    var sut: GameViewModel!
    var questionService: QuestionService!
    
    override func setUp() {
        super.setUp()
        questionService = QuestionService.shared
        sut = GameViewModel()
    }
    
    override func tearDown() {
        sut = nil
        questionService = nil
        super.tearDown()
    }
    
    func testCompleteGameFlow() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        
        // When
        sut.startGame()
        
        // Then
        XCTAssertEqual(sut.gameState, .player1Turn)
        XCTAssertNotNil(sut.currentQuestion)
        
        // Simulate a complete game where Player 1 wins 3 rounds
        for _ in 0..<3 {
            let correctAnswer = sut.currentQuestion?.correctAnswer ?? ""
            
            // Player 1 answers correctly
            sut.submitAnswer(correctAnswer)
            
            // Player 2 answers incorrectly
            sut.submitAnswer("wrong answer")
        }
        
        // Verify game over when a player wins 3 rounds
        XCTAssertEqual(sut.gameState, .gameOver)
        XCTAssertEqual(sut.player1.roundWins, 3)
        XCTAssertEqual(sut.player2.roundWins, 0)
        XCTAssertEqual(sut.roundResults.count, 3)
    }
    
    func testGameContinuesUntilWinner() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        
        // When - Play 4 rounds with alternating wins
        for i in 0..<4 {
            let correctAnswer = sut.currentQuestion?.correctAnswer ?? ""
            
            if i % 2 == 0 {
                // Player 1 wins this round
                sut.submitAnswer(correctAnswer)
                sut.submitAnswer("wrong answer")
            } else {
                // Player 2 wins this round
                sut.submitAnswer("wrong answer")
                sut.submitAnswer(correctAnswer)
            }
        }
        
        // Then - Game should continue as no player has won 3 rounds
        XCTAssertNotEqual(sut.gameState, .gameOver)
        XCTAssertEqual(sut.player1.roundWins, 2)
        XCTAssertEqual(sut.player2.roundWins, 2)
        XCTAssertEqual(sut.roundResults.count, 4)
    }
    
    func testQuestionServiceIntegration() {
        // Given
        let question = questionService.getRandomQuestion()
        
        // Then
        XCTAssertNotNil(question)
        XCTAssertFalse(question.text.isEmpty)
        XCTAssertFalse(question.options.isEmpty)
        XCTAssertFalse(question.correctAnswer.isEmpty)
    }
    
    func testPlayerScoreTracking() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        
        // When
        sut.submitAnswer("A")
        sut.submitAnswer("B")
        
        // Then
        XCTAssertGreaterThanOrEqual(sut.player1Score, 0)
        XCTAssertGreaterThanOrEqual(sut.player2Score, 0)
        
        // Verify score updates
        let initialPlayer1Score = sut.player1Score
        let initialPlayer2Score = sut.player2Score
        
        sut.submitAnswer("A")
        sut.submitAnswer("B")
        
        XCTAssertGreaterThanOrEqual(sut.player1Score, initialPlayer1Score)
        XCTAssertGreaterThanOrEqual(sut.player2Score, initialPlayer2Score)
    }
    
    func testRoundTransition() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        
        // When
        sut.submitAnswer("A")
        sut.submitAnswer("B")
        
        // Then
        XCTAssertEqual(sut.currentRound, 2)
        XCTAssertEqual(sut.gameState, .player1Turn)
        XCTAssertNotNil(sut.currentQuestion)
    }
    
    func testGameReset() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        
        // When
        sut.submitAnswer("A")
        sut.submitAnswer("B")
        sut.submitAnswer("A")
        sut.submitAnswer("B")
        sut.submitAnswer("A")
        sut.submitAnswer("B")
        
        // Then
        XCTAssertEqual(sut.gameState, .gameOver)
        
        // When resetting
        sut.startGame()
        
        // Then
        XCTAssertEqual(sut.currentRound, 1)
        XCTAssertEqual(sut.gameState, .player1Turn)
        XCTAssertTrue(sut.roundResults.isEmpty)
        XCTAssertEqual(sut.currentTime, 0)
    }
    
    func testTimerIntegration() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        
        // When
        let initialTime = sut.currentTime
        
        // Then
        XCTAssertEqual(initialTime, 0)
        
        // Wait for a short time
        let expectation = XCTestExpectation(description: "Timer update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        // Verify timer has updated
        XCTAssertGreaterThan(sut.currentTime, initialTime)
    }
} 