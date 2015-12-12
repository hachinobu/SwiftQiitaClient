//: Playground - noun: a place where people can play

import UIKit
import Timepiece
import SwiftTask

var str = "Hello, playground"

let dateStr = "2015-12-06T10:59:17+09:00"
let format = dateStr.dateFromFormat("yyyy-MM-dd'T'HH:mm:ssZZZZZ")!
let today = NSDate()

if today.year - format.year > 0 {
   print(today.year - format.year)
}

if today.month - format.month > 0 {
    print(today.month - format.month)
}

if today.day - format.day > 0 {
    print(today.day - format.day)
}

today.day - format.day

if today.hour - format.hour > 0 {
    print(today.hour - format.hour)
}

let diff = format.timeIntervalSinceNow


let p = NSCalendar.currentCalendar().components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: format, toDate: NSDate(), options: [])
p.year
p.month
p.day
p.hour
p.minute

let x = NSCalendar.currentCalendar().components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: NSDate())
//    components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: NSDate()).

typealias TaskType = Task<Float, Int, NSError>

let task1 = TaskType { (progress, fulfill, reject, configure) -> Void in
    return fulfill(1)
}

let task2 = TaskType { (progress, fulfill, reject, configure) -> Void in
    return fulfill(2)
}

let task3 = TaskType { (progress, fulfill, reject, configure) -> Void in
    return reject(NSError(domain: "domain", code: 10000, userInfo: nil))
    return fulfill(3)
}

task1.then { (value, errorInfo: (error: NSError?, isCancelled: Bool)?) -> Int in
    return value ?? 0
    
}.success { (value: Int) -> Void in
    print(value)
}

task1.then { (value, errorInfo: (error: NSError?, isCancelled: Bool)?) -> TaskType in
    return task2
}.success { (value) -> Void in
    print(value)
}



//Task.all([task1, task2, task3]).then { (values, erorrInfo: (error: NSError?, isCancelled: Bool)?) -> TaskType? in
//    print("then")
//    guard let values = values else {
//        return nil
//    }
//    let total = values.reduce(0, combine: { (var total: Int, value: Int) -> Int in
//        return total + value
//    })
//    
//    return TaskType { (progress, fulfill, reject, configure) -> Void in
//        return reject(NSError(domain: "domain", code: 10000, userInfo: nil))
//    }
//    
//}.success { (task: TaskType?) -> Void in
//        print("succ")
//        task!.success { (value: Int) -> Void in
//            print(value)
//            }.failure({ (error, isCancelled) -> Void in
//                print("failure")
//            })
//}.failure { (error, isCancelled) -> Void in
//        print("fail")
//}

Task.all([task1, task2, task3]).success { (values) -> TaskType in
    
    print("success")
    let total = values.reduce(0, combine: { (var total: Int, value: Int) -> Int in
        return total + value
    })
    
    return TaskType { (progress, fulfill, reject, configure) -> Void in
        return fulfill(total)
    }
    
}.success { (value: Int) -> Void in
    print(value)
}.failure { (error, isCancelled) -> Void in
    print("fail")
}

Task.all([task1, task2, task3]).success { (values) -> Void in
    
    print("success")
    
    TaskType { (progress, fulfill, reject, configure) -> Void in
        return fulfill(10)
    }.success { value -> Void in
        print(value)
    }
    
}.failure { (error, isCancelled) -> Void in
    print("fail")
}

Task.all([task1, task2]).success { values -> Void in
    
    task3.success { (value) -> Void in
        print(value)
    }.failure { (error, isCancelled) -> Void in
        print("task3 failure")
    }
    
}.failure { (error, isCancelled) -> Void in
    print("all failure")
}

Task.any([task3, task2, task1]).success { (value: Int) -> Void in
    print("success \(value)")
}.failure { (error, isCancelled) -> Void in
    print("failure")
}

Task.some([task1, task2, task3]).success { (values) -> Void in
    print("value \(values)")
}.failure { (error, isCancelled) -> Void in
    print("fail")
}


