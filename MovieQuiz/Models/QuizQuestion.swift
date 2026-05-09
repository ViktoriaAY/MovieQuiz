//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 19.04.2026.
//

import Foundation

public struct QuizQuestion: Hashable {
    let image: Data
    let text: String
    let correctAnswer: Bool
}
