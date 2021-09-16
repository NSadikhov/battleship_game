import Foundation

class EGB_Engine {
    enum Who {
        case player, opponent
    }
    
    private var boardPlayer: EGB_Board
    private var boardOpponent: EGB_Board
    
    init(rows: Int = 10, cols: Int = 10) {
        self.boardPlayer = EGB_Board(rows: rows, cols: cols)
        self.boardOpponent = EGB_Board(rows: rows, cols: cols)
    }
    
    func printBoards() {
        print("\nPLAYER\n")
        boardPlayer.printBoard()
        print("\nOPPONENT\n")
        boardOpponent.printBoard()
    }
    
    func printBoard(who: Who) {
        if who == Who.player {
            print("\nPLAYER\n")
            boardPlayer.printBoard()
        } else {
            print("\nOPPONENT\n")
            boardOpponent.printBoard()
        }
    }
    
    func getWhoBoard(who: Who) -> EGB_Board {
        if who == Who.player {
            return boardPlayer
        }
        
        return boardOpponent
    }
    
    func mayPlaceShip(
        who: Who,
        size: Int,
        anchorRow: Int,
        anchorCol: Int,
        direction: EGB_Ship.Direction
    ) -> Bool {
        
        let anchor = (row: anchorRow, col: anchorCol)
        let boardWho = getWhoBoard(who: who)
        return boardWho.mayPlaceShip(size: size,
                                     anchor: anchor,
                                     direction: direction)
    }
    
    func placeShip(
        who: Who,
        size: Int,
        anchorRow: Int,
        anchorCol: Int,
        direction: EGB_Ship.Direction
    ) {
        
        let anchor = (row: anchorRow, col: anchorCol)
        let boardWho = getWhoBoard(who: who)
        boardWho.placeShip(size: size,
                           anchor: anchor,
                           direction: direction)
    }
    
    func placeShipIfPossible(who: Who,
                             size: Int,
                             anchorRow: Int,
                             anchorCol: Int,
                             direction: EGB_Ship.Direction
    ) -> Bool {
        
        let x = mayPlaceShip(who: who,
                             size: size,
                             anchorRow: anchorRow,
                             anchorCol: anchorCol,
                             direction: direction)
        
        if x {placeShip(who: who,
                        size: size,
                        anchorRow: anchorRow,
                        anchorCol: anchorCol,
                        direction: direction)
            
            return true
        }
        
        return false
    }
    
}
