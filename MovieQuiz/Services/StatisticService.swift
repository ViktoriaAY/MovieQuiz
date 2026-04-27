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
    case correct
    case total
}

final class StatisticService: StatisticServiceProtocol {
    
    private let userDefaults: UserDefaults = .standard
    private var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    private var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
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
            guard total != 0 else { return 0 }
            return (Double(correct) / Double(total)) * 100
        }
    }
    
    func storeCurrentResult(currentResult: GameResult) {
        correct += currentResult.correct
        total += currentResult.total
        gamesCount += 1
        if currentResult.store(with: bestGame) {
            bestGame = currentResult
        }
    }
}



