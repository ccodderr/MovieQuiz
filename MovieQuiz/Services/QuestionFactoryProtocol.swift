//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 04.10.2024.
//

import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    func requestNextQuestion()
    func loadData()
}
