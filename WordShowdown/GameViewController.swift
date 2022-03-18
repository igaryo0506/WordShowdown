//
//  GameViewController.swift
//  WordShowdown
//
//  Created by 五十嵐諒 on 2022/03/16.
//

import UIKit

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
    
    var timer:Timer?
    
    let maxTime = 30.0
    
    var leftTime = 0.0
    
    var tempAlphabets:[String] = []
    
    let alphabets:[String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var isWaiting = false
    
    var letterNum = 0
    
    let maxQuizNum = 5
    
    var quizNum = 0
    
    var quizzes:[Quiz] = [Quiz(question:"こんにちは", answer: "HELLO"),
                        Quiz(question: "放棄する", answer: "ABANDON"),
                        Quiz(question: "プログラミング", answer: "PROGRAMMING"),
                        Quiz(question: "卓球", answer: "TABLETENNIS"),
                        Quiz(question: "踊る", answer: "DANCE")]
    
    lazy var quiz:Quiz = quizzes[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if gamemode == 0 {
            secondPlayerNameLabel?.text = ""
            secondPlayerColonLabel?.text = ""
            secondPlayerAnswerLabel?.text = ""
        }
        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup(){
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
        okImage?.isHidden = false
        next()
    }
    
    func incorrect(){
        ngImage?.isHidden = false
        next()
    }
    
    func next(){
        timer?.invalidate()
        isWaiting = true
        if maxQuizNum > quizNum+1{
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(nextQuiz), userInfo: nil, repeats: false)
        }else{
            self.performSegue(withIdentifier: "toResult", sender: nil)
        }
        print("next")
    }
    
    @objc func nextQuiz(){
        isWaiting = false
        quizNum += 1
        quiz = quizzes[quizNum]
        setup()
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
