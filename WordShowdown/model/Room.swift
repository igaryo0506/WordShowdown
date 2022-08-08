//
//  Room.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/08/08.
//

import Foundation
class Room{
    let id:String
    var firstUid:String = ""
    var secondUid:String = ""
    var isWaitingForMatch:Bool
    var isMatched:Bool
    var fStatus:Int = 0
    var sStatus:Int = 0
    init(id: String) {
        self.id = id
        isWaitingForMatch = true
        isMatched = false
    }
}
