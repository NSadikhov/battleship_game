import Foundation

class EGB_Board {
    var rows, cols: Int
    private var board: [[CellType]]
    private var ships: EGB_Ships

    enum CellType {
        case none, empty, hit, notAllowed, rescue, ship, shot
    }

    init(rows: Int = 10, cols: Int = 10) {
        self.rows = rows
        self.cols = cols

        board = Array(repeating: Array(repeating: .none,
                                       count: cols+2),
                      count: rows+2)

        ships = EGB_Ships()
        prepareBoard()
    }
    
    func getShipCount() -> Int {
        return ships.shipsAtCommand
    }
    
    func hitAt(row: Int, col: Int, isDestroyed: inout Bool) -> Bool {
        let r = row + 1
        let c = col + 1
        if(board[r][c] == .ship){
            board[r][c] = .hit
            for (_, ship) in ships.ships {
                if ship.hitAt(row: r, col: c){
                    isDestroyed = ship.isDestroyed
                    break;
              }
            }
            return true
        }
        board[r][c] = .shot
        return false
    }

    func prepareBoard() {
        for i in 0...rows+1 {
            board[i][0] = .notAllowed
            board[i][cols+1] = .notAllowed
        }

        for i in 0...cols+1 {
            board[0][i] = .notAllowed
            board[rows+1][i] = .notAllowed
        }

        for r in 1...rows {
            for c in 1...cols {
                board[r][c] = .empty
            }
        }
    }

    func printBoard() {
        let leadingPadding = EGB_Utils.determineNumberOfDigits(number: rows)
        var leadingPaddingString = ""
        var line = ""
        var digit = 0

        for _ in 1...leadingPadding {
            leadingPaddingString += " "
        }

        line = leadingPaddingString + "  "
        for c in 0..<cols {
            digit = c%10
            line += " \(digit)"
        }

        print(line)

        for r in 0...rows+1 {
            line = ""

            if r == 0 || r == rows+1 {
                line += leadingPaddingString + " "
            } else {
                line += String(r-1).leftPadding(toLength: leadingPadding, withPad: " ") + " "
            }

            for c in 0...cols+1 {
                switch board[r][c] {
                case .empty:
                    line += "0 "
                case .hit:
                    line += "! "
                case .ship:
                    line += "X "
                case .shot:
                    line += "* "
                case .none:
                    line += "? "
                case .notAllowed:
                    line += "# "
                case .rescue:
                    line += "O "
                }
            }

            print(line)
        }
    }

    func mayPlaceShip(
        size: Int,
        anchor: (row: Int, col: Int),
        direction: EGB_Ship.Direction
    ) -> Bool {
        var modifier = (forRow: 0, forCol: 0)
        var r = 0
        var c = 0

        switch direction {
        case .up:
            modifier = (forRow: -1, forCol:  0)
        case .down:
            modifier = (forRow: +1, forCol:  0)
        case .left:
            modifier = (forRow:  0, forCol: -1)
        case .right:
            modifier = (forRow:  0, forCol: +1)
        }

        for i in 0...size-1 {
            r = (anchor.row + 1) + i * modifier.forRow
            c = (anchor.col + 1) + i * modifier.forCol

            guard r>0, r<rows+1 else {return false}
            guard c>0, c<cols+1 else {return false}

            if board[r][c] != .empty {
                return false
            }
        }

        return true
    }


    func placeShip(
      size: Int,
      anchor: (row: Int, col: Int),
      direction: EGB_Ship.Direction
    ) {
      var modifier = (forRow: 0, forCol: 0)
      var r = 0
      var c = 0
      var position = [(row: Int, col: Int, status: EGB_Ship.Status)]()

      switch direction {
      case .up:
        modifier = (forRow: -1, forCol:  0)
      case .down:
        modifier = (forRow: +1, forCol:  0)
      case .left:
        modifier = (forRow:  0, forCol: -1)
      case .right:
        modifier = (forRow:  0, forCol: +1)
      }

      for i in 0...size-1 {
        r = (anchor.row + 1) + i * modifier.forRow
        c = (anchor.col + 1) + i * modifier.forCol

        board[r][c] = CellType.ship
        position.append((row: r,
                         col: c,
                         status: EGB_Ship.Status.ready))
      }

      ships.ships["\(anchor)"] =
        EGB_Ship(size: size, position: position)
    }
    
    func placeShipIfPossible(size: Int,
                             anchorRow: Int,
                             anchorCol: Int,
                             direction: EGB_Ship.Direction
    ) -> Bool {
        
        let x = mayPlaceShip(size: size,
                             anchor: (anchorRow, anchorCol),
                             direction: direction)
        
        if x {placeShip(size: size,
                        anchor: (anchorRow, anchorCol),
                        direction: direction)
            
            return true
        }
        
        return false
    }
}


