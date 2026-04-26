//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 23.04.2026.
//
import Foundation
import UIKit

final class ResultAlertPresenter {
    func showAlert(model: AlertModel, ui: UIViewController) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in model.completion()
        }
        alert.addAction(action)
        ui.present(alert, animated: true, completion: nil)
    }
}
