//: Playground - noun: a place where people can play

import UIKit
import Bond

let numA = Observable<Int>(0)

//定義時でも処理が走る
numA.observe { (value) -> Void in
    print("observe \(value)")
}

//定義時には無視される
numA.observeNew { (value) -> Void in
    print("observeNew \(value)")
}

numA.next(2)

//片方向Binding
let numB = Observable<Int>(10)
let numC = Observable<Int>(11)
//numB observe valueをnumC.next(value)している
let disposeNumB = numB.bindTo(numC)
numC.value

//bindingを切る
disposeNumB.dispose()
numB.next(12)
numB.value
numC.value

//map observe時にtransformを元に値変換した値を元にEventProducerを作成する
//public func map<T>(transform: EventType -> T) -> EventProducer<T> {
//    return EventProducer(replayLength: replayLength) { sink in
//        return observe { event in
//            sink(transform(event))
//        }
//    }
//}

let numD = Observable<Int>(100)
let numDStr = numD.map { (value) -> String in
    print("map \(value)")
    return String(value)
}.map { (value) -> String in
    print("value: \(value)")
    return "value: \(value)"
}

numD.observers.count
numDStr.observers.count
numD.next(100)
numD.value
numD.observers.count
numDStr.observers.count
numDStr.deinitDisposable.dispose()
numD.observers.count
numDStr.observers.count

numDStr.observe { (value) -> Void in
    print("numDStr \(value)")
}
numD.observe { (value) -> Void in
    
}
numD.observers.count
numDStr.observers.count

numD.next(102)
//紐付け削除
numDStr.deinitDisposable.dispose()
numD.next(103)


// filter 条件に合う場合のみその値のEventProducerを生成する
let filterNum = Observable<Int>(200)
filterNum.observe { (value) -> Void in
    print("observable filterNum")
}

let filterEventProducer = filterNum.filter { (value) in
    return value % 2 == 0
}

filterEventProducer.observe { (value) -> Void in
    print("filterObserve \(value)")
}

filterNum.next(2)

//条件に合わないので登録されているobserveが実行されない
filterNum.next(13)

//deliverOn 渡したQueue内で非同期でEventProducerを生成する
//BackgroundスレッドとMainスレッドで交互に処理するような時に有効
//Backgroundで画像ダウンロードしてMainで紐付けみたいな
let image = Observable<UIImage>(UIImage())
let urlStr = Observable<String>("http://gazou")
urlStr.deliverOn(.Background).map { (ulr) -> UIImage in
    return UIImage()
}.deliverOn(.Main).bindTo(image)

let deliverOnNum = Observable<Int>(300)
deliverOnNum.deliverOn(.Background).map { value in
    return String(value)
}
deliverOnNum.next(233)

//startwith 最初の初期化でも処理実行したい場合
let startNum = Observable(20)
startNum.observe { (value) -> Void in
    print("before startwith　\(value)")
}
let startEventP = startNum.startWith(2)
startEventP.observe { (value) -> Void in
    print("startEventP")
}

startNum.next(100)


//combineLatestWith
let numE = Observable(3)
let numF = Observable(4)
let numEF = numE.combineLatestWith(numF)
numEF.observe { (value1, value2) -> Void in
    print(value1 + value2)
}

numE.next(10)
numF.next(10)



//flatmap
let flatNum1 = Observable(1)
let flatNum2 = Observable(2)
let flatEP = flatNum1.flatMap(.Latest) { (value) in
    return Observable(String(value))
}
flatEP.observe { (value) -> Void in
    print("fep \(value)")
}

let flatEP2 = flatNum2.flatMap(.Merge) { (value) in
    return Observable(String(value))
}
flatEP2.observe { (value) -> Void in
    print("fep2 \(value)")
}

flatNum1.next(3)
flatNum2.next(12)

//ignoreNil
let nilNumA = Observable<Int?>(nil)
nilNumA.observe { (value) -> Void in
    print(value)
}

let nilEP = nilNumA.ignoreNil()
nilEP.observe { (value) -> Void in
    print("nilEP \(value)")
}
nilNumA.next(1)

//distinct
let disNum1 = Observable(1)

let disEP = disNum1.distinct()
disEP.observe { (value) -> Void in
    print("dis \(value)")
}

disNum1.next(1)
disNum1.next(2)











