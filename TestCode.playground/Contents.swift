//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

for i in 0...5 {
    println(i)
}

var a = [1,2,3,5]
a.sort {$0 > $1}
a

let b = a.filter {$0 < 2}
a
b

let sum = a.reduce(0) {$0 + $1}
sum

var s = "hello"
let index = advance(s.startIndex, 2)
s.splice("abc", atIndex: index)
s
let startIndex = advance(s.startIndex, 0)
let endIndex = advance(s.startIndex, 6)
let substring = s[s.startIndex...endIndex]

assert(0 < 1, "good")
assert(1 > 2, "bad")


import UIKit
let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
println(view.contentScaleFactor)
