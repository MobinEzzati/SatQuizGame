# Trival Game - iOS SAT Math Quiz Game

A two-player trivia game focused on SAT math questions, built with SwiftUI.

## Screenshots

### Start Screen
![Start Screen](screenshots/start_screen.png)
*Players can enter their names to begin the game*

### Gameplay
![Gameplay Screen](screenshots/gameplay.png)
*Players take turns answering SAT math questions*

### Results
![Results Screen](screenshots/results.png)
*End of round results showing scores and performance*

## Features
- Two-player turn-based gameplay
- SAT math questions with multiple choice answers
- Timer-based rounds
- Score tracking and round results
- Beautiful UI with animated frog mascot
- Rainbow gradient theme

## Technical Details
- Built with SwiftUI
- MVVM Architecture
- iOS 18.0+
- Xcode 15+

## Game Flow
1. **Start Screen**
   - Enter player names
   - Beautiful animated frog logo
   - Rainbow gradient buttons

2. **Gameplay**
   - Players take turns answering questions
   - Timer counts down for each question
   - Animated transitions between turns
   - Score tracking in real-time

3. **Results**
   - Round summary with scores
   - Correct/incorrect answer tracking
   - Time taken per question
   - Option to play again

## Installation
1. Clone the repository
2. Open TrivalGame.xcodeproj in Xcode
3. Build and run on simulator or device

## Model Structure
```swift
struct Player {
    let id: UUID
    let name: String
    var score: Int
    var roundWins: Int
    var totalTime: TimeInterval
    var answers: [PlayerAnswer]
}

struct PlayerAnswer {
    let questionId: UUID
    let answer: String
    let timeTaken: TimeInterval
    let isCorrect: Bool
    let timestamp: Date
}
```

## How to Play
1. Launch the game and enter player names
2. Each player takes turns answering SAT math questions
3. Score points for correct answers
4. Complete three rounds
5. Player with the highest score wins!

## Development
- Written in Swift using SwiftUI
- Follows MVVM architecture pattern
- Uses custom animations and transitions
- Implements reusable UI components
- Includes comprehensive unit tests
