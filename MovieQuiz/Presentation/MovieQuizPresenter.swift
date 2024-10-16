//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 16.10.2024.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    var alertPresenter: AlertPresentProtocol
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private var correctAnswers = 0
    
    init(
        viewController: MovieQuizViewControllerProtocol,
        alertPresenter: AlertPresentProtocol
    ) {
        self.viewController = viewController
        self.alertPresenter = alertPresenter
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
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
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }

        let givenAnswer = isYes

        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            statisticService?.store(
                correct: correctAnswers,
                total: questionsAmount
            )
            alertPresenter.showAlert(
                alertModel: makeResultsMessage()
            )
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        viewController?.updateState(isCorrect ? .correct : .wrong)
        correctAnswers += isCorrect ? 1 : 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
            viewController?.updateState(.waiting)
        }
    }
    
    func restartGame() {
        resetQuestionIndex()
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func makeResultsMessage() -> AlertModel {
        let result = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0 )
        Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(questionsAmount) (\(statisticService?.bestGame.date.dateTimeString ?? " "))
        Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%
        """,
            buttonText: "Сыграть еще раз")
        
        let alert = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText) { [weak self] in
                self?.restartGame()
            }
        return alert
    }
}
