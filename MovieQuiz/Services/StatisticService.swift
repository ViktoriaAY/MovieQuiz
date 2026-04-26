//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 26.04.2026.
//

import Foundation

private enum Keys: String {
    case gamesPlayedCounter
    case bestGameCorrect
    case bestGameTotal
    case bestGameDate
    case totalAccuracy
    case totalCorrectAnswers
    case totalQuestionsAsked
}

final class StatisticService: StatisticServiceProtocol {
    
    private let userDefaults: UserDefaults = .standard
    private var totalCorrectAnswers: Int {
        get {
            userDefaults.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    private var totalQuestionsAsked: Int {
        get {
            userDefaults.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesPlayedCounter.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesPlayedCounter.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = userDefaults.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = userDefaults.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = userDefaults.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date ()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            userDefaults.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            userDefaults.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            userDefaults.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            guard totalQuestionsAsked != 0 else { return 0 }
            return (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100
        }
    }
    
    func storeCurrentResult(currentResult: GameResult) {
        totalCorrectAnswers += currentResult.correct
        totalQuestionsAsked += currentResult.total
        gamesCount += 1
        if currentResult.comparisonRecords(with: bestGame) {
            bestGame = currentResult
        }
    }
}



