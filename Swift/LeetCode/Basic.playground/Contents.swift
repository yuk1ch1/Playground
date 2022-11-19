import UIKit

func calculate(num: Int) -> Int {
    var count = 0 // O(1)
    
    // O(n^2)
    //
    // 単純なループ分の入れ子の場合計算量が多く、n^2回実行されてしまうので処理が遅い
    for _ in 0..<num {
        for _ in 0..<num {
            count += 1
        }
    }
    
    // O(n^2)
    for _ in 0..<num {
        for _ in 0..<num {
            count += 1
        }
    }

    return count // O(1)
}


let result1 = calculate(num: 4)

/*
 計算量の算出方法(参照: https://qiita.com/cotrpepe/items/1f4c38cc9d3e3a5f5e9c)
 
 1. 各行のステップ数を求める
 
 - 1
 - n^2
 - n^2
 - 1

 2. プログラム全体のステップを求める
 1+n^2+n^2+1
 = 2+2n^2
 
 3. 不要なものを取り除く
 
 a. 最大次数の項以外を除く(計算量を求める際は、低次項を無視し、最大次数の項だけを残す)
 *計算量は入力サイズが十分に大きいことを前提としていて、入力サイズが大きい場合、低次項の重要性が相対的に低くなるため
 
 2+n+2n^2 -> 2n^2
 
 b. 係数を除く(計算量の定義上、定数倍程度の違いは無視することになっているため)
 n^2
 
 
 結果: O(n^2)
 
 */
