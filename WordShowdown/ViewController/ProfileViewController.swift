//
//  ProfileViewController.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/03/18.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet var textField:UITextField?
    
    let db = Firestore.firestore()
    var uid : String?
    var id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        uid = UserDefaults.standard.string(forKey: "uid")
    }
    
    @IBAction func clickedChangeNameButton(){
        db.collection("users").document(uid!).updateData(["name": self.textField?.text ?? ""])
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
