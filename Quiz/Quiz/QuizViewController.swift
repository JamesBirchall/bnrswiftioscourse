//
//  ViewController.swift
//  Quiz
//
//  Created by James Birchall on 08/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    //@IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var currentQuestionLabel: UILabel!
    @IBOutlet weak var nextQuestionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var answerButton: UIButton!
    
    var questionsAndAnswers = QuestionsAndAnswers()
    
    enum LabelType {
        case question
        case answer
    }
    
    @IBAction func showQuestion() {
        currentQuestionLabel.alpha = 0
        animateLabelTransitions(label: .question)
        
        nextQuestionLabel.text = questionsAndAnswers.shareQuestion()
        
        answerButton.isEnabled = true
        questionButton.isEnabled = false

        answerLabel.text = "???"
        
    }
    
    @IBAction func showAnswer() {
        answerLabel.alpha = 0
        animateLabelTransitions(label: .answer)
        
        answerLabel.text = questionsAndAnswers.shareAnswer()
        questionsAndAnswers.incrementIndex()
        
        answerButton.isEnabled = false
        questionButton.isEnabled = true
        
    }
    
    override func viewDidLoad() {
        answerButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentQuestionLabel.alpha = 0
        nextQuestionLabel.alpha = 0
        animateLabelTransitions(label: .question)
    }
    
    func animateLabelTransitions(label: LabelType) {
        
//        let animationClosure = {
//            () -> Void in
//            self.questionLabel.alpha = 1
//        }
//        
//        UIView.animate(withDuration: 2, animations: animationClosure)
        
        // implicit return type and input paramters
        
//        switch label {
//        case .question:
//            UIView.animate(withDuration: 0.5, animations: { self.questionLabel.alpha = 1 })
//        case .answer:
//            UIView.animate(withDuration: 0.5, animations: { self.answerLabel.alpha = 1 })
//        }
        
        // more consise use improvement!
//        UIView.animate(withDuration: 0.5, animations: { () -> Void in
//            switch label {
//            case .question:
//                self.currentQuestionLabel.alpha = 1
//            case .answer:
//                self.answerLabel.alpha = 1
//            }
//        })
        
        // animations have completion handlers to do some activty once they have completed such as swapping references
        
        UIView.animate(withDuration: 2.0, animations: {
            () -> Void in
            switch label {
            case .question:
                self.currentQuestionLabel.alpha = 0
                self.nextQuestionLabel.alpha = 1
            case .answer:
                self.answerLabel.alpha = 1
            }
            }, completion: {
                _ in
                switch label {
                case .question:
                    swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
                case .answer:
                    break
                }
                
        })
    }
}

