import Foundation


class EGB_AI {
    private var AI_Board: EGB_Board
    private var opponentBoard: EGB_Board
    private var gameEngine: EGB_Engine
    private var attackBoard = [(Int, Int)]()
    
    private var prevSuccessHits = [(Int, Int)]()
    
    private var prevSuccess: Bool = false
    
    init(gameEngine: EGB_Engine, AI_Board: EGB_Board, opponentBoard: EGB_Board) {
        self.AI_Board = AI_Board
        self.opponentBoard = opponentBoard
        self.gameEngine = gameEngine
        
        for r in 0..<AI_Board.rows {
            for c in 0..<AI_Board.cols {
                attackBoard.append((r, c))
            }
        }
        
    }
    
    func hit () -> Bool {
        var randomPos: (Int, Int) = (0, 0)
        if(prevSuccess){
            var possiblePoses = [(Int, Int)]()
            for i in 0 ..< prevSuccessHits.count {
                if(prevSuccessHits.count == 1){
                    if prevSuccessHits[i].0 < AI_Board.rows - 1 && attackBoard.contains(where: { $0.0 == prevSuccessHits[i].0 + 1 && $0.1 == prevSuccessHits[i].1}) {
                        possiblePoses.append((prevSuccessHits[i].0 + 1, prevSuccessHits[i].1))
                    }
                    if prevSuccessHits[i].0 > 0 && attackBoard.contains(where: { $0.0 == prevSuccessHits[i].0 - 1 && $0.1 == prevSuccessHits[i].1}) {
                        possiblePoses.append((prevSuccessHits[i].0 - 1, prevSuccessHits[i].1))
                    }
                    if prevSuccessHits[i].0 < AI_Board.cols - 1 && attackBoard.contains(where: { $0.0 == prevSuccessHits[i].0 && $0.1 == prevSuccessHits[i].1 + 1}) {
                        possiblePoses.append((prevSuccessHits[i].0, prevSuccessHits[i].1 + 1))
                    }
                    if prevSuccessHits[i].0 > 0 && attackBoard.contains(where: { $0.0 == prevSuccessHits[i].0 && $0.1 == prevSuccessHits[i].1 - 1}) {
                        possiblePoses.append((prevSuccessHits[i].0, prevSuccessHits[i].1 - 1))
                    }
                }
                else {
                    if prevSuccessHits[0].0 == prevSuccessHits[1].0 {
                        prevSuccessHits.sort(by: { $0.1 > $1.1 })
                        
                        if(prevSuccessHits.first!.1 + 1 < AI_Board.cols &&
                            attackBoard.contains(where: { $0.0 == prevSuccessHits.first!.0 && $0.1 == prevSuccessHits.first!.1 + 1})) {
                            possiblePoses.append((prevSuccessHits.first!.0, prevSuccessHits.first!.1 + 1))
                        }
                        if(prevSuccessHits.last!.1 - 1 >= 0 &&
                            attackBoard.contains(where: { $0.0 == prevSuccessHits.last!.0 && $0.1 == prevSuccessHits.last!.1 - 1})) {
                            possiblePoses.append((prevSuccessHits.last!.0, prevSuccessHits.last!.1 - 1))
                        }
                    }
                    else {
                        prevSuccessHits.sort(by: { $0.0 > $1.0 })
                        
                        if(prevSuccessHits.first!.0 + 1 < AI_Board.rows &&
                            attackBoard.contains(where: { $0.0 == prevSuccessHits.first!.0 + 1 && $0.1 == prevSuccessHits.first!.1})) {
                            possiblePoses.append((prevSuccessHits.first!.0 + 1, prevSuccessHits.first!.1))
                        }
                        if(prevSuccessHits.last!.0 - 1 >= 0 &&
                            attackBoard.contains(where: { $0.0 == prevSuccessHits.last!.0 - 1 && $0.1 == prevSuccessHits.last!.1})) {
                            possiblePoses.append((prevSuccessHits.last!.0 - 1, prevSuccessHits.last!.1))
                        }
                    }
                }
                randomPos = possiblePoses.randomElement()!
            }
            
        } else {
            randomPos = attackBoard.randomElement()!
        }
        
        print("Position: \(randomPos) was attacked")
        var isDestroyed: Bool = false
        
        let index = attackBoard.firstIndex { $0.0 == randomPos.0 && $0.1 == randomPos.1 }
        attackBoard.remove(at: index!)
        
        if opponentBoard.hitAt(row: randomPos.0, col: randomPos.1, isDestroyed: &isDestroyed) {
            if(isDestroyed) { prevSuccess = false; prevSuccessHits.removeAll() }
            else {
                prevSuccess = true
                prevSuccessHits.append(randomPos)
            }
            return true
        } else{
            return false
        }
        
    }
    
    func placeShips(){
        func placeShipWithSize(size: Int, iterate: Int){
            for _ in 0 ..< iterate {
                var isPlaced: Bool = false
                while !isPlaced {
                    let randomRow = Array(0..<AI_Board.rows).randomElement()!
                    let randomCol = Array(0..<AI_Board.cols).randomElement()!
                    
                    let randomDir = [EGB_Ship.Direction.up, EGB_Ship.Direction.down, EGB_Ship.Direction.left, EGB_Ship.Direction.right].randomElement()!
                    
                    if(AI_Board.placeShipIfPossible(size: size, anchorRow: randomRow, anchorCol: randomCol, direction: randomDir)) {
                        isPlaced = true
                    }
                }
            }
        }
        
        
        placeShipWithSize(size: 4, iterate: 1)
        placeShipWithSize(size: 3, iterate: 2)
        placeShipWithSize(size: 2, iterate: 3)
        placeShipWithSize(size: 1, iterate: 4)
        
    }
}
