import Foundation

class EGB_Ship {
    enum Direction {
        case up, down, left, right
    }

    enum Status {
        case damaged, destroyed, ready
    }

    private let size: Int
    private var readyLevel: Int
    var position: [(row: Int, col: Int, status: Status)]

    var isDestroyed: Bool {
      return readyLevel == 0 ? true : false
    }

    init(size: Int,
         position: [(row: Int, col: Int, status: Status)]) {
      self.size = size
      self.position = position
      self.readyLevel = size
    }
    
    func hitAt(row: Int, col: Int) -> Bool{
        for (index, coordinate) in position.enumerated() {
            if coordinate.row == row &&
                coordinate.col == col {
                position[index].status = Status.damaged
                readyLevel -= 1
                return true
            }
        }
        return false
    }
}

