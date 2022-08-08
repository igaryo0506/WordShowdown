//
//  FirebaseUtils.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/08/08.
//

import Firebase
import UIKit

class FirebaseUtils{
    static let db = Firestore.firestore()
    
    static func initializeFirebaseUsername(uid:String){
        db.collection("users").document(uid).getDocument(completion: {(querySnapshot,err) in
            if !(querySnapshot?.exists ?? false) {
                self.db.collection("users").document(uid).setData(["name":"Unknown"])
            }
        })
    }
    
    static func makeRoom(uid:String,vc:TitleViewController){
        
        let roomId = Utils.generator(length: 8)
        
        let room = Room(id: roomId)
        room.firstUid = uid
        updateRoom(room: room)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "ルームを作成中"
        alert.message = "ルームIDは" + roomId + "です"
        alert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: {(action) -> Void in
            room.isWaitingForMatch = false
            updateRoom(room: room)
            alert.dismiss(animated: true)
        }))
        
        vc.makeAlert(alert: alert)
        
        var snapshotListener:ListenerRegistration! = nil
        snapshotListener = self.db.collection("rooms").document(roomId).addSnapshotListener{(documentSnapShot,error) in
            let documentSnapShot = documentSnapShot
            if (documentSnapShot?.get("isMatched") as! Bool) {
                snapshotListener.remove()
                alert.dismiss(animated: true, completion: nil)
                room.isWaitingForMatch = false
                updateRoom(room: room)
                vc.toGameViewController(room:room)
            }
        }
        
    }
    
    static func joinRoom(uid:String,vc:TitleViewController){
        print("ok")
        let alert = UIAlertController(title:nil,message: nil, preferredStyle: .alert)
        var alertTextField:UITextField?
        alert.title = "ルームに参加"
        alert.message = "ルームIDを入力してください"
        alert.addTextField(configurationHandler: {(textField) -> Void in
            alertTextField = textField
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: {(action) -> Void in
            print("cancel")
        }))
        alert.addAction(UIAlertAction(title: "参加", style: .default, handler: {(action) -> Void in
            let typedId = alertTextField?.text ?? ""
            print(typedId)
            self.db.collection("rooms").document(typedId).getDocument(completion: {(snapshot,err) in
                if snapshot?.exists != nil {
                    print("okok")
                    if snapshot?.get("isWaitingForMatch") as! Bool{
                        let room = Room(id: typedId)
                        room.isMatched = true
                        room.secondUid = uid
                        updateRoom(room: room)
                        vc.toGameViewController(room:room)
                    }
                }
            })
        }))
        vc.makeAlert(alert: alert)
    }
    
    static func getRoom(room:Room){
        db.collection("rooms").document(room.id).getDocument(completion: {(snapshot,err) in
            room.isWaitingForMatch = snapshot?.get("isWaitingForMatch") as! Bool
            room.isMatched = snapshot?.get("isMatched") as! Bool
            room.firstUid = snapshot?.get("firstUid") as! String
            room.secondUid = snapshot?.get("secondUid") as! String
        })
    }
    
    static func updateRoom(room:Room){
        db.collection("rooms")
            .document(room.id)
            .setData(
                ["isWaitingForMatch": room.isWaitingForMatch,
                 "isMatched": room.isMatched,
                 "firstUid": room.firstUid,
                 "secondUid": room.secondUid,
                 "fResults": [-1,-1,-1,-1,-1],
                 "sResults": [-1,-1,-1,-1,-1],
                 "fStatus": room.fStatus,
                 "sStatus": room.sStatus])
    }
}
