//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Yana Silosieva on 07.10.2024.
//

import Foundation
import UIKit

final class AlertPresenter: AlertPresentProtocol {
    weak var vc: UIViewController?
    
    init(vc: UIViewController?) {
        self.vc = vc
    }
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = "Game results"
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: { [alertModel] _ in alertModel.completion?() }
        )

        alert.addAction(action)
        //alert.identif
        vc?.present(alert, animated: true, completion: nil)
    }
}
