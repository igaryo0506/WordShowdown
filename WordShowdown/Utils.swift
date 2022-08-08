//
//  Utils.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/08/08.
//

import Foundation
class Utils{
    let ud = UserDefaults.standard
    static func initializeUser() -> String{
        var uid:String
        if UserDefaults.standard.string(forKey: "uid") == nil{
            uid = generator(length:16)
            UserDefaults.standard.set(uid, forKey: "uid")
        } else {
            uid = UserDefaults.standard.string(forKey: "uid")!
        }
        FirebaseUtils.initializeFirebaseUsername(uid: uid)
        return uid
    }
    
    static func getUid() -> String{
        return UserDefaults.standard.string(forKey: "uid") ?? ""
    }
    
    static func generator(length:Int) -> String {
        let letters = "0123456789"
        var randomString = ""
        for _ in 0 ..< length {
            randomString += String(letters.randomElement()!)
        }
        return randomString
    }
}
