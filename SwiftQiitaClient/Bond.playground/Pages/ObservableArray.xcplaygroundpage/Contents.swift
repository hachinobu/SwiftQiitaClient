import Foundation
import Bond
import UIKit

var array = [1,2,3]
var observableArray = ObservableArray(array)
observableArray.performBatchUpdates { (elements) -> Void in
    elements.append(4)
    elements.array = [1, 2, 3, 4, 5]
}
observableArray.array = [5, 6, 7, 8]
observableArray.array = [7]
observableArray.append(1)
//observableArray[0]
var generate = observableArray.generate()
generate.next()
generate.next()
ObservableArray<String>()

let liftArray = observableArray.lift()

for (sectionIndex, rowValueArray) in liftArray.enumerate() {
    rowValueArray.array
}

liftArray.array = [ObservableArray([1, 2, 3, 4])]
liftArray.append(ObservableArray([10, 20, 30, 40]))
liftArray.append(ObservableArray([100, 200, 300, 400]))

for (section, rowValueArray) in liftArray.enumerate() {
    print(rowValueArray.array)
}

liftArray.array.append(ObservableArray([1]))
liftArray.array[0].append(5)

for (section, rowValueArray) in liftArray.enumerate() {
    print(rowValueArray.array)
}

liftArray.count
liftArray.array[0].array

let tuppleA = (str: "a", num: 1)
let observableTuppleArray = ObservableArray([tuppleA])
let dataSource = observableTuppleArray.lift()
let tuppleB = (str: "b", num: 2)
dataSource.append([tuppleB])
for (section, rowValueArray) in dataSource.enumerate() {
    print(rowValueArray.array)
}


//let numArray = ObservableArray([1, 2, 3, 4])
//let strArray = ObservableArray(["a", "b", "c"])
//
//let combineArray = combineLatest(numArray, strArray)
//let tableArray = ObservableArray([combineArray])
//
//
//combineArray.observe { (intArray, strArray) -> Void in
//    print(intArray.sequence)
//    print(strArray.sequence)
//}
//
//strArray.append("d")





