//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 23.04.2026.
//
import Foundation
import UIKit

final class AlertPresenter {
     func showAllert(model: AlertModel, ui: UIViewController) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in model.completion()
        }
        alert.addAction(action)
        ui.present(alert, animated: true, completion: nil)
    }
}







//    AlertModel(title: result.title,
//                                message: result.text,
//                                buttonText: result.buttonText,
//                                completion: <#T##() -> Void#>)
//}
//    let alert = UIAlertController(title: result.title,
//                                  message: result.text,
//                                  preferredStyle: .alert)
//    let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
//        guard let self = self else { return }
//        self.currentQuestionIndex = 0
//        self.correctAnswers = 0
//        self.questionFactory?.reset()
//        questionFactory?.requestNextQuestion()
//    }
//    alert.addAction(action)
//    self.present(alert, animated: true, completion: nil)
//}
