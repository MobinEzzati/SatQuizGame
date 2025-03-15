import XCTest
@testable import TrivalGame

final class GameViewModelTests: XCTestCase {
    var sut: GameViewModel!
    
    override func setUp() {
        super.setUp()
        sut = GameViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(sut.currentRound, 1)
        XCTAssertNil(sut.currentQuestion)
        XCTAssertNil(sut.currentPlayer)
        XCTAssertEqual(sut.gameState, .notStarted)
        XCTAssertTrue(sut.roundResults.isEmpty)
        XCTAssertEqual(sut.currentTime, 0)
        XCTAssertFalse(sut.isTransitioning)
        XCTAssertTrue(sut.player1Name.isEmpty)
        XCTAssertTrue(sut.player2Name.isEmpty)
    }
    
    func testCanStartGame() {
        // Test empty names
        XCTAssertFalse(sut.canStartGame)
        
        // Test one empty name
        sut.player1Name = "Player 1"
        XCTAssertFalse(sut.canStartGame)
        
        // Test both names filled
        sut.player2Name = "Player 2"
        XCTAssertTrue(sut.canStartGame)
    }
    
    func testStartGame() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        
        // When
        sut.startGame()
        
        // Then
        XCTAssertEqual(sut.gameState, .player1Turn)
        XCTAssertNotNil(sut.currentPlayer)
        XCTAssertEqual(sut.currentPlayer?.name, "Player 1")
        XCTAssertNotNil(sut.currentQuestion)
    }
    
    func testSubmitAnswer() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        
        // When
        sut.submitAnswer("A")
        
        // Then
        XCTAssertEqual(sut.gameState, .player2Turn)
        XCTAssertEqual(sut.currentPlayer?.name, "Player 2")
    }
    
    func testRoundResults() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        
        // When
        sut.submitAnswer("A")
        sut.submitAnswer("B")
        
        // Then
        XCTAssertFalse(sut.roundResults.isEmpty)
        XCTAssertEqual(sut.currentRound, 2)
    }
    
    func testGameOver() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        
        // When - Player 1 wins 3 rounds
        for _ in 0..<3 {
            // Player 1 answers correctly
            sut.submitAnswer(sut.currentQuestion?.correctAnswer ?? "")
            // Player 2 answers incorrectly
            sut.submitAnswer("wrong answer")
        }
        
        // Then
        XCTAssertEqual(sut.gameState, .gameOver)
        XCTAssertEqual(sut.player1.roundWins, 3)
        XCTAssertEqual(sut.player2.roundWins, 0)
    }
    
    func testTieRound() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        
        // When - Both players answer incorrectly
        sut.submitAnswer("wrong answer")
        sut.submitAnswer("wrong answer")
        
        // Then
        XCTAssertEqual(sut.player1.roundWins, 0)
        XCTAssertEqual(sut.player2.roundWins, 0)
        XCTAssertNil(sut.roundResults.last?.winner)
    }
    
    func testFasterPlayerWinsWhenBothCorrect() {
        // Given
        sut.player1Name = "Player 1"
        sut.player2Name = "Player 2"
        sut.startGame()
        let correctAnswer = sut.currentQuestion?.correctAnswer ?? ""
        
        // Simulate different answer times
        // Player 1 answers quickly
        sut.submitAnswer(correctAnswer)
        
        // Player 2 answers correctly but slower
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sut.submitAnswer(correctAnswer)
        }
        
        // Then
        XCTAssertEqual(sut.player1.roundWins, 1)
        XCTAssertEqual(sut.player2.roundWins, 0)
        XCTAssertEqual(sut.roundResults.last?.winner?.id, sut.player1.id)
    }
    
    func testPlayerScores() {
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
    }
} 