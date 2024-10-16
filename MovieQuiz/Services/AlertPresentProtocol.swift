//
//  AlertPresentProtocol.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 07.10.2024.
//

import Foundation
import UIKit

protocol AlertPresentProtocol {
    var vc: UIViewController? { get }
    
    func showAlert(alertModel: AlertModel)
}
