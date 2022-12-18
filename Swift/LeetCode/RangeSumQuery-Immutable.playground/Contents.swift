import UIKit

class NumArrayMyAnswer {
    let nums: [Int]
    init(_ nums: [Int]) {
        self.nums = nums
    }

    func sumRange(_ left: Int, _ right: Int) -> Int {
        return nums[left...right].reduce(0, +)
    }
}





class NumArrayBestAnswer {
    var pref = [0]
    init(_ nums: [Int]) {
        pref = nums.reduce(into: [0]) {
            $0.append($0.last! + $1) // 元の配列から各要素に対して一つ前の筋を足して新しい配列を作成
        }
    }
    
    // イニシャライズ時に事前に必要な処理はしてあるから、このメソッド自体のcomplexityはn(1)で済む
    func sumRange(_ l: Int, _ r: Int) -> Int {
        return pref[r+1] - pref[l]
    }
}
let numArray = NumArrayBestAnswer([-2,0,3,-5,2,-1, 4, 5, -6, 7, 100])
numArray.sumRange(0, 9)
