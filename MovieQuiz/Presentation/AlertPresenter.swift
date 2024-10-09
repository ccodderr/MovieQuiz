//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 07.10.2024.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresentProtocol {
    
    weak var delegate: AlertPresentDelegate?

    func showAlert() {
        guard let alertModel = delegate?.makeAlertModel(),
              let viewController = delegate as? UIViewController
        else { return }
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: { [alertModel] _ in alertModel.completion?() }
        )

        alert.addAction(action)

        viewController.present(alert, animated: true, completion: nil)
    }
}
