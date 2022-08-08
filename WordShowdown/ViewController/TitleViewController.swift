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
    
    var room:Room?
    
    let db = Firestore.firestore()
    
    var isFirstPlayer = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        uid = Utils.initializeUser()
        
        makeRoomButton?.isHidden = true
        joinRoomButton?.isHidden = true
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
        FirebaseUtils.makeRoom(uid: Utils.getUid(),vc:self)
    }
    
    @IBAction func clickedJoinRoomButton(){
        FirebaseUtils.joinRoom(uid:Utils.getUid(),vc: self)
    }
    
    func toGameViewController(room:Room){
        self.performSegue(withIdentifier: "toGame", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            let nextView = segue.destination as! GameViewController
            nextView.gamemode = gamemode
            if(gamemode == 1){
                nextView.roomId = room?.id
                nextView.isFirstPlayer = isFirstPlayer
            }
        }
    }
    
    func makeAlert(alert:UIAlertController){
        present(alert,animated: true, completion: {
            print("alert presented")
        })
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
