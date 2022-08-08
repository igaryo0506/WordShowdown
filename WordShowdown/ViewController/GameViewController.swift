//
//  GameViewController.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/03/16.
//

import UIKit
import Firebase

class GameViewController: UIViewController {

    @IBOutlet var questionLabel:UILabel?
    @IBOutlet var answerLabel:UILabel?
    
    @IBOutlet var button0:UIButton?
    @IBOutlet var button1:UIButton?
    @IBOutlet var button2:UIButton?
    @IBOutlet var button3:UIButton?
    
    @IBOutlet var okImage:UIImageView?
    @IBOutlet var ngImage:UIImageView?
    
    @IBOutlet var progressView:UIProgressView?
    
    @IBOutlet var firstPlayerNameLabel:UILabel?
    @IBOutlet var firstPlayerColonLabel:UILabel?
    @IBOutlet var firstPlayerAnswerLabel:UILabel?
    @IBOutlet var secondPlayerNameLabel:UILabel?
    @IBOutlet var secondPlayerColonLabel:UILabel?
    @IBOutlet var secondPlayerAnswerLabel:UILabel?
    
    // 0 -> ソロプレイ 1 -> マルチプレイ
    var gamemode = 0
    
    var roomId:String?
    
    var timer:Timer?
    
    let maxTime = 30.0
    
    var leftTime = 0.0
    
    var tempAlphabets:[String] = []
    
    let alphabets:[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    var isWaiting = false
    
    var letterNum = 0
    
    let db = Firestore.firestore()
    
    var roomRef:DocumentReference?
    
    var isFirstPlayer:Bool = false
    
    var fresults:[Int] = []
    
    var sresults:[Int] = []
    
    var game = Game()
    
    lazy var quiz:Quiz = game.quizzes[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        sleep(1)
        
        if gamemode == 0 {
            secondPlayerNameLabel?.text = ""
            secondPlayerColonLabel?.text = ""
            secondPlayerAnswerLabel?.text = ""
            setup()
        }else{
            roomRef = db.collection("rooms").document(roomId!)
            updateDatas()
            setup()
        }
    }

    func updateDatas(){
        var firstPlayerName:String?
        var secondPlayerName:String?
        var firstPlayerId:String?
        var secondPlayerId:String?
        var firstPlayerAnswer:String = ""
        var secondPlayerAnswer:String = ""
        roomRef?.getDocument(completion: { (documentSnapshot, error) in
            firstPlayerId = documentSnapshot?.get("firstPlayerId") as? String
            secondPlayerId = documentSnapshot?.get("secondPlayerId") as? String
            
            self.fresults = documentSnapshot?.get("fresults") as! Array
            
            self.sresults = documentSnapshot?.get("sresults") as! Array
            
            self.db.collection("users").document(firstPlayerId!).getDocument(completion:{ (documentSnapshot, error) in
                firstPlayerName = documentSnapshot?.get("name") as? String
                self.firstPlayerNameLabel?.text = firstPlayerName ?? "いがりょう"
            })
            
            self.db.collection("users").document(secondPlayerId!).getDocument(completion:{ (documentSnapshot, error) in
                secondPlayerName = documentSnapshot?.get("name") as? String
                self.secondPlayerNameLabel?.text = secondPlayerName ?? "いがりょう"
            })
            
            for x in self.fresults{
                if x == -1{
                    firstPlayerAnswer += "□"
                }else if x == 0{
                    firstPlayerAnswer += "X"
                }else{
                    firstPlayerAnswer += "O"
                }
            }
            for x in self.sresults{
                if x == -1{
                    secondPlayerAnswer += "□"
                }else if x == 0{
                    secondPlayerAnswer += "X"
                }else{
                    secondPlayerAnswer += "O"
                }
            }
            self.firstPlayerAnswerLabel?.text = firstPlayerAnswer
            self.secondPlayerAnswerLabel?.text = secondPlayerAnswer
        })
    }
    
    func setup(){
        print("setup")
        letterNum = 0
        okImage?.isHidden = true
        ngImage?.isHidden = true
        leftTime = maxTime
        progressView?.setProgress(Float(leftTime / maxTime), animated: false)
        questionLabel?.text = quiz.question
        var answerText = ""
        for _ in 0 ..< quiz.answerLength{
            answerText += " _"
        }
        answerLabel?.text = answerText
        print(getAlphabet(str: quiz.answer, num: letterNum))
        setAlphabets(c:getAlphabet(str: quiz.answer, num: letterNum))
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(GameViewController.timerUpdate),userInfo: nil,repeats: true)
    }
    
    @objc func timerUpdate(){
        if (game.quizNum >= game.maxQuizNum){
            return
        }
        leftTime -= 0.05
        progressView?.setProgress(Float(leftTime / maxTime), animated: true)
        if(leftTime < 0){
            timer?.invalidate()
            progressView?.setProgress(0, animated: true)
            incorrect()
        }
    }
    
    @IBAction func clickedButton(_ sender:UIButton){
        if !isWaiting{
            let clickedButton:Int = sender.tag
            check(clickedButton: clickedButton)
        }
    }
    
    func getAlphabet(str:String,num:Int) -> String{
        let startIndex = str.index(str.startIndex,offsetBy: num)
        return String(str[startIndex])
    }
    
    func check(clickedButton:Int){
        let answerLetter = getAlphabet(str: quiz.answer, num: letterNum)
        print(answerLetter,tempAlphabets[clickedButton])
        if answerLetter == tempAlphabets[clickedButton] {
            nextLetter()
        } else {
            incorrect()
        }
    }
    
    func nextLetter(){
        if gamemode == 1{
            updateDatas()
        }
        var answerText = ""
        for x in 0 ..< quiz.answerLength{
            if x <= letterNum {
                answerText += getAlphabet(str: quiz.answer, num: x)
                answerText += " "
            }else{
                answerText += "_ "
            }
        }
        answerLabel?.text = answerText
        if letterNum + 1 >= quiz.answerLength{
            correct()
        }else{
            letterNum += 1
            
            setAlphabets(c: getAlphabet(str: quiz.answer, num: letterNum))
        }
    }
    
    func setAlphabets(c:String){
        tempAlphabets = []
        tempAlphabets.append(c)
        while tempAlphabets.count < 4 {
            let alphabet:String = alphabets.randomElement()!
            if(!tempAlphabets.contains(alphabet)){
                tempAlphabets.append(alphabet)
            }
        }
        tempAlphabets.shuffle()
        button0?.setTitle(tempAlphabets[0], for: .normal)
        button1?.setTitle(tempAlphabets[1], for: .normal)
        button2?.setTitle(tempAlphabets[2], for: .normal)
        button3?.setTitle(tempAlphabets[3], for: .normal)
    }
    
    func correct(){
        if gamemode == 1{
            if isFirstPlayer{
                fresults[game.quizNum] = 1
            }else{
                sresults[game.quizNum] = 1
            }
        }
        next()
    }
    
    func incorrect(){
        if gamemode == 1{
            if isFirstPlayer{
                fresults[game.quizNum] = 0
            }else{
                sresults[game.quizNum] = 0
            }
        }
        
        next()
    }
    
    func next(){
        timer?.invalidate()
        isWaiting = true
        if gamemode == 1{
            var listener:ListenerRegistration! = nil
            listener = roomRef?.addSnapshotListener{(documentSnapshot,error) in
                if self.isFirstPlayer{
                    if (documentSnapshot?.get("sisWaiting") as! Bool) {
                        print("ok")
                        self.checkQuizNum()
                        listener.remove()
                        self.roomRef?.updateData(["sisWaiting":false])
                    }
                }else{
                    if  (documentSnapshot?.get("fisWaiting") as! Bool){
                        print("ok")
                        self.checkQuizNum()
                        listener.remove()
                        self.roomRef?.updateData(["fisWaiting":false])
                    }
                }
                
            }
            if isFirstPlayer {
                roomRef?.updateData(["fisWaiting":true,"fresults":fresults])
            }else{
                roomRef?.updateData(["sisWaiting":true, "sresults":sresults])
            }
        }else{
            checkQuizNum()
        }
        
    }
    
    func checkQuizNum(){
        if game.maxQuizNum > game.quizNum+1{
            invalidateButton()
            sleep(1)
            validateButton()
            nextQuiz()
            print("next")
        }else{
            self.performSegue(withIdentifier: "toResult", sender: nil)
            print("toResult")
        }
    }
    
    func invalidateButton(){
        button0?.isEnabled = false
        button1?.isEnabled = false
        button2?.isEnabled = false
        button3?.isEnabled = false
    }
    
    func validateButton(){
        button0?.isEnabled = true
        button1?.isEnabled = true
        button2?.isEnabled = true
        button3?.isEnabled = true
    }
    
    func nextQuiz(){
        isWaiting = false
        game.quizNum += 1
        quiz = game.quizzes[game.quizNum]
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("finish")
        timer?.invalidate()
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
