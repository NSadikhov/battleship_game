import Foundation

class EGB_Utils {
    // Type method
    class func determineNumberOfDigits(number: Int) -> Int {
        var value = 10

        guard number > 0 else {return 0}

        for digits in 1...10 {
            if (value > number) {
                return digits
            }
            value *= 10
        }  

        return 0
    }
}
