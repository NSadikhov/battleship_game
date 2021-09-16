// Manual Ship Setup for battleship game
// Artificial Intelligence for computer playing battleship game

import Foundation

let game = EGB_Engine(rows: 10, cols: 10)
game.printBoard(who: .player)


print("\n<<< 10 ships must be placed to play the game >>>")
print("( Ship size -> Amount )")
print("Ship with size of 4 -> 1")
print("Ship with size of 3 -> 2")
print("Ship with size of 2 -> 3")
print("Ship with size of 1 -> 4")

func placeShips(size: Int, iterate: Int = 1) {
    for _ in 0 ..< iterate {
        var isPlaced: Bool = false
        while(!isPlaced){
            print("\nEnter the position of ship with size of \(size) (e.g. 3,4): ", terminator: "")
            let shipPos = (readLine()!).split(separator: ",")
            if(shipPos.count != 2) {print("\n<<< Wrong format, Try again >>>"); continue}
            print("Enter the direction (up = 0, down = 1, left = 2, right = 3): ", terminator: "")
            let direction = Int(readLine()!)!
            var shipDir: EGB_Ship.Direction
            switch direction {
            case 0:
                shipDir = .up
                break
            case 1:
                shipDir = .down
                break
            case 2:
                shipDir = .left
                break
            case 3:
                shipDir = .right
                break
            default:
                shipDir = .down
            }
            
            if game.placeShipIfPossible(who: .player, size: size, anchorRow: Int(shipPos[0])!, anchorCol: Int(shipPos[1])!, direction: shipDir) {
                isPlaced = true
                game.printBoard(who: .player)
            }
            else {
                print("<<< Ship could not be placed, try another position/direction >>>")
            }
        }
    }
    
}

placeShips(size: 4, iterate: 1)
placeShips(size: 3, iterate: 2)
placeShips(size: 2, iterate: 3)
placeShips(size: 1, iterate: 4)

let ai = EGB_AI(gameEngine: game, AI_Board: game.getWhoBoard(who: .opponent), opponentBoard: game.getWhoBoard(who: .player))

ai.placeShips()

print("\n\t\t<<<<<< Game Started >>>>>>")
var whoseTurn: EGB_Engine.Who = .player
var gameFinished: Bool = false
while(!gameFinished) {
    if(whoseTurn == .player){
        game.printBoard(who: .opponent)
        
        var hasMissed: Bool = false
        while !hasMissed {
            print("\nThe Board above belongs to Opponent, Enter a position (e.g. 2,5) to hit any ship: ", terminator: "")
            let oppShipPos = (readLine()!).split(separator: ",")
            if(oppShipPos.count != 2) {print("\n<<< Wrong format, Try again >>>"); continue}
            var isDestroyed: Bool = false
            if !game.getWhoBoard(who: .opponent).hitAt(row: Int(oppShipPos[0])!, col: Int(oppShipPos[1])!, isDestroyed: &isDestroyed) {
                hasMissed = true
                whoseTurn = .opponent
                print("\n<<< You missed it >>>")
            } else {
                game.printBoard(who: .opponent)
                if(game.getWhoBoard(who: .opponent).getShipCount() == 0) {
                    print("\n <<< YOU WON >>>")
                    gameFinished = true
                    break
                }
                print("\n<<< You \(isDestroyed ? "destroyed" : "hit") the ship, Try again >>>")
            }
        }
    }
    else {
        game.printBoard(who: .player)
        var hasMissed: Bool = false
        while !hasMissed {
            print("\nThe Board above belongs to You, Now Computer will be attacking to your ships")
            //            var isDestroyed: Bool = false
            if !ai.hit() {
                hasMissed = true
                whoseTurn = .player
                game.printBoard(who: .player)
                print("\n<<< Computer missed it >>>")
            } else {
                game.printBoard(who: .player)
                if(game.getWhoBoard(who: .player).getShipCount() == 0) {
                    print("\n <<< COMPUTER WON >>>")
                    gameFinished = true
                    break
                }
                print("\n<<< Computer hit your ship >>>")
            }
        }
    }
    
}
