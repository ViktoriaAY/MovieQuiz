//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 22.04.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
