//
//  File.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/03/16.
//

import Foundation

class Quiz {
    let question:String
    let answer:String
    var startTime:Int? = nil
    var endTime: Int? = nil
    var answerLength = 0
    init(question:String, answer: String){
        self.question = question
        self.answer = answer
        self.answerLength = answer.count
    }
}
