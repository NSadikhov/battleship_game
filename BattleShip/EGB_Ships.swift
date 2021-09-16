import Foundation

class EGB_Ships {
  var ships = [String: EGB_Ship]()
    
  var shipsAtCommand: Int {
    var shipsNumber = ships.count

    for (_, ship) in ships {
      if ship.isDestroyed {
        shipsNumber -= 1
      }
    }

    return shipsNumber
  }
}
