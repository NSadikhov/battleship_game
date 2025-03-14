# BattleShip Game

This console application is an implementation of the BattleShip game in Swift.

## Overview

- Two boards are used for gameplay: one for the player and one for the opponent.
- The player manually places 10 ships (size 4:1, size 3:2, size 2:3, size 1:4), while the computer randomly places its ships.
- The AI places and hits ships based on simple strategies.

## How to Play

1. The game starts by placing your ships manually. You will be prompted to enter the ship's starting position (e.g., 3,4) and a direction (up = 0, down = 1, left = 2, right = 3).
2. After ship placement, the game begins. You and the computer take turns to attack.
3. Enter target positions to hit the opponent’s ships. If you hit a ship, you get another turn until you miss.
4. The game ends when all ships of one side are destroyed.

## Build and Run

- Open the project in Xcode.
- Build using Swift 5.0.
- Run the project from Xcode’s console.

## File Structure

- `EGB_AI.swift`: AI logic for attacking and ship placement.
- `EGB_Board.swift`: Implementation of the game board.
- `EGB_Ship.swift` and `EGB_Ships.swift`: Ship data structures and hit detection.
- `EGB_Engine.swift`: Game engine that manages turns and gameplay.
- `main.swift`: Entry point managing user input and game loop.
- `EGB_Extensions.swift` & `EGB_Utils.swift`: Utility functions and string extensions.
