//
//  TitleViewController.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/03/16.
//

import UIKit

class TitleViewController: UIViewController {

    var gamemode = 0
    
    @IBOutlet var multiPlayButton:UIButton?
    @IBOutlet var makeRoomButton:UIButton?
    @IBOutlet var joinRoomButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
//        gamemode = 1
//        self.performSegue(withIdentifier: "toGame", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            let nextView = segue.destination as! GameViewController
            nextView.gamemode = gamemode
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
