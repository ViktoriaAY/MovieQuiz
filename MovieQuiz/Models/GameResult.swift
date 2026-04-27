//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 26.04.2026.
//
import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func store (with other: GameResult) -> Bool {
        return self.correct > other.correct
    }
}
