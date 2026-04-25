//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 23.04.2026.
//
import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}

