//
//  ViewController.swift
//  Quiz
//
//  Created by James Birchall on 08/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var answerButton: UIButton!
    
    var questionsAndAnswers = QuestionsAndAnswers()
    
    @IBAction func showQuestion() {
        questionLabel.text = questionsAndAnswers.shareQuestion()
        
        answerButton.isEnabled = true
        questionButton.isEnabled = false
        
        answerLabel.text = "???"
    }
    
    @IBAction func showAnswer() {
        answerLabel.text = questionsAndAnswers.shareAnswer()
        questionsAndAnswers.incrementIndex()
        
        answerButton.isEnabled = false
        questionButton.isEnabled = true
    }
    
    override func viewDidLoad() {
       answerButton.isEnabled = false
    }
}

