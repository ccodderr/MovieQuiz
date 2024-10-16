//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 16.10.2024.
//

import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func updateState(_ state: QuestionState)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
