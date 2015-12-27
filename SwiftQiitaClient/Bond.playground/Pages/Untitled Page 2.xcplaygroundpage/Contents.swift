import Foundation
import Bond

let observableNum1 = Observable(1)
var num1: Int = 0
observableNum1.map { $0 + 1 }.map { $0 + 10 }.observe { (value) in
    num1 = value
}
num1

observableNum1.next(2)
num1
observableNum1.observers.count

observableNum1.map { String($0) }
observableNum1.observers.count