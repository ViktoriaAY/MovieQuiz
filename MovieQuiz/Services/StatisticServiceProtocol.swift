//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 26.04.2026.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get } 
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    func storeCurrentResult(currentResult: GameResult)
}

