import XCTest

final class GameViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testStartGameFlow() throws {
        // Test initial state
        XCTAssertTrue(app.textFields["Player 1 Name"].exists)
        XCTAssertTrue(app.textFields["Player 2 Name"].exists)
        XCTAssertTrue(app.buttons["Start Game"].exists)
        XCTAssertFalse(app.buttons["Start Game"].isEnabled)
        
        // Enter player names
        app.textFields["Player 1 Name"].tap()
        app.textFields["Player 1 Name"].typeText("Player 1")
        
        app.textFields["Player 2 Name"].tap()
        app.textFields["Player 2 Name"].typeText("Player 2")
        
        // Verify start button is enabled
        XCTAssertTrue(app.buttons["Start Game"].isEnabled)
        
        // Start game
        app.buttons["Start Game"].tap()
        
        // Verify game state
        XCTAssertTrue(app.staticTexts["Round 1"].exists)
        XCTAssertTrue(app.staticTexts["Player 1's Turn"].exists)
        XCTAssertTrue(app.staticTexts["0.0"].exists) // Timer
    }
    
    func testAnswerSubmission() throws {
        // Start game
        app.textFields["Player 1 Name"].tap()
        app.textFields["Player 1 Name"].typeText("Player 1")
        
        app.textFields["Player 2 Name"].tap()
        app.textFields["Player 2 Name"].typeText("Player 2")
        
        app.buttons["Start Game"].tap()
        
        // Wait for question to appear
        let questionButton = app.buttons.element(boundBy: 0)
        XCTAssertTrue(questionButton.waitForExistence(timeout: 5))
        
        // Submit answer
        questionButton.tap()
        
        // Verify transition to player 2
        XCTAssertTrue(app.staticTexts["Player 2's Turn"].exists)
    }
    
    func testRoundResults() throws {
        // Complete a round
        app.textFields["Player 1 Name"].tap()
        app.textFields["Player 1 Name"].typeText("Player 1")
        
        app.textFields["Player 2 Name"].tap()
        app.textFields["Player 2 Name"].typeText("Player 2")
        
        app.buttons["Start Game"].tap()
        
        // Submit answers for both players
        let questionButton = app.buttons.element(boundBy: 0)
        XCTAssertTrue(questionButton.waitForExistence(timeout: 5))
        questionButton.tap()
        
        let questionButton2 = app.buttons.element(boundBy: 0)
        XCTAssertTrue(questionButton2.waitForExistence(timeout: 5))
        questionButton2.tap()
        
        // Verify results screen
        XCTAssertTrue(app.staticTexts["Round 1 Results"].exists)
        XCTAssertTrue(app.buttons["Continue"].exists)
    }
    
    func testGameOver() throws {
        // Complete 3 rounds
        app.textFields["Player 1 Name"].tap()
        app.textFields["Player 1 Name"].typeText("Player 1")
        
        app.textFields["Player 2 Name"].tap()
        app.textFields["Player 2 Name"].typeText("Player 2")
        
        app.buttons["Start Game"].tap()
        
        for _ in 0..<3 {
            let questionButton = app.buttons.element(boundBy: 0)
            XCTAssertTrue(questionButton.waitForExistence(timeout: 5))
            questionButton.tap()
            
            let questionButton2 = app.buttons.element(boundBy: 0)
            XCTAssertTrue(questionButton2.waitForExistence(timeout: 5))
            questionButton2.tap()
            
            if _ < 2 {
                app.buttons["Continue"].tap()
            }
        }
        
        // Verify game over screen
        XCTAssertTrue(app.staticTexts["Game Over!"].exists)
        XCTAssertTrue(app.staticTexts["Final Score"].exists)
        XCTAssertTrue(app.buttons["Play Again"].exists)
    }
    
    func testPlayAgain() throws {
        // Complete a game
        app.textFields["Player 1 Name"].tap()
        app.textFields["Player 1 Name"].typeText("Player 1")
        
        app.textFields["Player 2 Name"].tap()
        app.textFields["Player 2 Name"].typeText("Player 2")
        
        app.buttons["Start Game"].tap()
        
        // Submit answers for both players
        let questionButton = app.buttons.element(boundBy: 0)
        XCTAssertTrue(questionButton.waitForExistence(timeout: 5))
        questionButton.tap()
        
        let questionButton2 = app.buttons.element(boundBy: 0)
        XCTAssertTrue(questionButton2.waitForExistence(timeout: 5))
        questionButton2.tap()
        
        // Tap play again
        app.buttons["Play Again"].tap()
        
        // Verify game reset
        XCTAssertTrue(app.staticTexts["Round 1"].exists)
        XCTAssertTrue(app.staticTexts["Player 1's Turn"].exists)
    }
} 