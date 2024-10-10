//
//  AlertPresentDelegate.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 07.10.2024.
//

import Foundation
import UIKit

protocol AlertPresentDelegate: UIViewController {
    func makeAlertModel() -> AlertModel
}
