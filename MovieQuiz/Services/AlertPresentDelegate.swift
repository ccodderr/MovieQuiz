//
//  AlertPresentDelegate.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 07.10.2024.
//

import Foundation

protocol AlertPresentDelegate: AnyObject {
    func makeAlertModel() -> AlertModel
}
