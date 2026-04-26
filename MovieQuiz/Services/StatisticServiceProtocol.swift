//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 26.04.2026.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get } //количество завершённых игр
    var bestGame: GameResult { get } //лучшая попытка
    var totalAccuracy: Double { get } //средняя точность правильных ответов
    
    func storeCurrentResult(currentResult: GameResult) //метод для сохранения текущего результата игры
}

