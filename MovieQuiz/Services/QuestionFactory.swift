//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 03.10.2024.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "TheGodfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "TheDarkKnight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "KillBill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "TheAvengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "TheGreenKnight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "TheIceAgeAdventuresOfBuckWild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        )
    ]
}
