//
//  Game.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/08/08.
//

import Foundation
struct Game {
    let maxQuizNum = 5
    
    var quizNum = 0
    
    var quizzes:[Quiz] = []
    
    var quizNums:[Int] = []
    
    var resList:[Int] = [-1,-1,-1,-1,-1]
    
    init(){
        var arr: [Int] = Array(0..<quizList.count)
        arr.shuffle()
        for i in 0..<maxQuizNum {
            quizzes.append(quizList[arr[i]])
            quizNums.append(arr[i])
        }
    }
}
