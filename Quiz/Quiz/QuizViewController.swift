//
//  ViewController.swift
//  Quiz
//
//  Created by James Birchall on 08/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

/*
 To Do: 
 * Want to add this into Stack View but have a problem with Constraints on sides of the top label which is animated in.  Can we keep those but still manage stack view?
 
 */

import UIKit

class QuizViewController: UIViewController {

    //@IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var currentQuestionLabel: UILabel!
    @IBOutlet weak var nextQuestionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var answerButton: UIButton!
    
    // Layout Constraints for flying in labels!
    @IBOutlet weak var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    
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
        updateOffScreenLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentQuestionLabel.alpha = 0
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
        
//        UIView.animate(withDuration: 0.5, animations: {
//            () -> Void in
//            switch label {
//            case .question:
//                self.view.layoutIfNeeded()
//                let screenWidth = self.view.frame.width
//                self.nextQuestionLabelCenterXConstraint.constant = 0
//                self.currentQuestionLabelCenterXConstraint.constant += screenWidth
//                self.currentQuestionLabel.alpha = 0
//                self.nextQuestionLabel.alpha = 1
//                self.view.layoutIfNeeded()  // redraws is needed
//            case .answer:
//                self.answerLabel.alpha = 1
//            }
//            }, completion: {
//                _ in
//                switch label {
//                case .question:
//                    swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
//                    swap(&self.currentQuestionLabelCenterXConstraint, &self.nextQuestionLabelCenterXConstraint)
//                    self.updateOffScreenLabel()
//                case .answer:
//                    break
//                }
//                
//        })
        
//        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: {
//            () -> Void in
//            switch label {
//            case .question:
//                self.view.layoutIfNeeded()
//                let screenWidth = self.view.frame.width
//                self.nextQuestionLabelCenterXConstraint.constant = 0
//                self.currentQuestionLabelCenterXConstraint.constant += screenWidth
//                self.currentQuestionLabel.alpha = 0
//                self.nextQuestionLabel.alpha = 1
//                self.view.layoutIfNeeded()  // redraws is needed
//            case .answer:
//                self.answerLabel.alpha = 1
//            }
//        }, completion: {
//            _ in
//            switch label {
//            case .question:
//                swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
//                swap(&self.currentQuestionLabelCenterXConstraint, &self.nextQuestionLabelCenterXConstraint)
//                self.updateOffScreenLabel()
//            case .answer:
//                break
//            }
//            
//        })
        
        
        // spring animation
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.65,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseIn],
                       animations: {
                        () -> Void in
                        switch label {
                        case .question:
                            self.view.layoutIfNeeded()
                            let screenWidth = self.view.frame.width
                            self.nextQuestionLabelCenterXConstraint.constant = 0
                            self.currentQuestionLabelCenterXConstraint.constant += screenWidth
                            self.currentQuestionLabel.alpha = 0
                            self.nextQuestionLabel.alpha = 1
                            self.view.layoutIfNeeded()  // redraws is needed
                        case .answer:
                            self.answerLabel.alpha = 1
                        }
        },
                       completion: {
                        _ in
                        switch label {
                        case .question:
                            swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
                            swap(&self.currentQuestionLabelCenterXConstraint, &self.nextQuestionLabelCenterXConstraint)
                            self.updateOffScreenLabel()
                        case .answer:
                            break
                        }
                        
        })
    }
    
    func updateOffScreenLabel() {
        // set nextQuestionLabel to be moved offscreen to start with
        let screenWidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = -screenWidth
    }
}

