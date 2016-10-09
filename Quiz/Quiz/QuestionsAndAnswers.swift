//
//  QuestionsAndAnswers.swift
//  Quiz
//
//  Created by James Birchall on 09/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import Foundation

struct QuestionsAndAnswers {
    
    let questions = ["From what is cognac made?","What is 7+7?","What is the capital of Vermont?"]
    let answers = ["Grapes","14","Montpelier"]
 
    var currentIndex = 0
    
    func shareQuestion() -> String {
        return questions[currentIndex]
    }
    
    func shareAnswer() -> String {
        return answers[currentIndex]
    }
    
    mutating func incrementIndex() {
        currentIndex = currentIndex + 1
        if currentIndex == questions.count {
            currentIndex = 0
        }
    }
}
