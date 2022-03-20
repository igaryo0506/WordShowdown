//
//  TitleViewController.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/03/16.
//

import UIKit
import Firebase

class TitleViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var multiPlayButton:UIButton?
    @IBOutlet var makeRoomButton:UIButton?
    @IBOutlet var joinRoomButton:UIButton?
    
    var uid:String?
    var gamemode = 0
    
    var roomId:String?
    
    let db = Firestore.firestore()
    
    var isFirstPlayer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if UserDefaults.standard.string(forKey: "uid") == nil{
            UserDefaults.standard.set(generator(length:16), forKey: "uid")
        }
        uid = UserDefaults.standard.string(forKey: "uid")
        
        makeRoomButton?.isHidden = true
        joinRoomButton?.isHidden = true
        db.collection("users").document(uid!).getDocument(completion: {(querySnapshot,err) in
            if !(querySnapshot?.exists ?? false) {
                self.db.collection("users").document(self.uid!).setData(["name":"Unknown"])
            }
        })
    }
    
    func generator(length:Int) -> String {
        let letters = "0123456789"
        var randomString = ""
        for _ in 0 ..< length {
            randomString += String(letters.randomElement()!)
        }
        return randomString
    }
    
    @IBAction func clickedSoloPlayButton(){
        gamemode = 0
        self.performSegue(withIdentifier: "toGame", sender: nil)
    }

    @IBAction func clickedMultiPlayButton(){
        makeRoomButton?.isHidden = !(makeRoomButton?.isHidden ?? true)
        joinRoomButton?.isHidden = !(joinRoomButton?.isHidden ?? true)
        gamemode = 1
//        self.performSegue(withIdentifier: "toGame", sender: nil)
    }
    
    @IBAction func clickedMakeRoomButton(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "ルームを作成中"
        roomId = generator(length: 8)
        db.collection("rooms").document(roomId!).setData(["isWaitingForMatch":true,"isMatched":false])
        
        var snapshotListener:ListenerRegistration! = nil
        snapshotListener = self.db.collection("rooms").document(self.roomId!).addSnapshotListener{(documentSnapShot,error) in
            let documentSnapShot = documentSnapShot
            if (documentSnapShot?.get("isMatched") as! Int)  != 0 {
                snapshotListener.remove()
                // Todo secondPlayerIdを削除
                self.db.collection("rooms").document(self.roomId!).updateData(
                    ["firstPlayerId":self.uid!,
                     "secondPlayerId":"0438555060977725",
                     "fresults": [-1,-1,-1,-1,-1],
                     "sresults": [-1,-1,-1,-1,-1],
                     "fisWaiting": false,
                     "sisWaiting": false])
                alert.dismiss(animated: true, completion: nil)
                self.isFirstPlayer = true
                self.matched()
            }
        }
        alert.message = "ルームIDは" + roomId! + "です"
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: {(action) -> Void in
            print("cancel")
            snapshotListener.remove()
            self.db.collection("rooms").document(self.roomId!).updateData(["isWaitingForMatch":false])
        }))
        self.present(alert,animated: true, completion: {print("alert presented")})
        
    }
    
    @IBAction func clickedJoinRoomButton(){
        let alert = UIAlertController(title:nil,message: nil, preferredStyle: .alert)
        var alertTextField:UITextField?
        alert.title = "ルームに参加"
        alert.message = "ルームIDを入力してください"
        alert.addTextField(configurationHandler: {(textField) -> Void in
            textField.delegate = self
            alertTextField = textField
        })
        alert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: {(action) -> Void in
            print("cancel")
        }))
        alert.addAction(UIAlertAction(title: "参加", style: .default, handler: {(action) -> Void in
            let typedId = alertTextField?.text ?? ""
            self.db.collection("rooms").document(typedId).getDocument(completion: {(snapshot,err) in
                if snapshot?.exists != nil {
                    if (snapshot?.get("isWaitingForMatch") as! Int) != 0{
                        self.roomId = typedId
                        self.db.collection("rooms").document(typedId).updateData(["isMatched":true])
                        self.db.collection("rooms").document(self.roomId!).updateData(["secondPlayerId":self.uid!])
                        self.isFirstPlayer = false
                        self.matched()
                    }
                }
            })
            print(alertTextField?.text ?? "")
        }))
        self.present(alert,animated: true, completion: {print("alert presented")})
    }
    
    func matched(){
        print("matched!")
        self.performSegue(withIdentifier: "toGame", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            let nextView = segue.destination as! GameViewController
            nextView.gamemode = gamemode
            if(gamemode == 1){
                nextView.roomId = roomId
                nextView.isFirstPlayer = isFirstPlayer
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
