//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 16.10.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func noButtonClicked() {
        getCorrectAnswer(userAnswer: false)
    }
    
    func yesButtonClicked() {
        getCorrectAnswer(userAnswer: true)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func getCorrectAnswer(userAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = userAnswer == currentQuestion.correctAnswer
        
        viewController?.showAnswerResult(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            viewController?.showNextQuestionOrResults()
        }
    }
}
