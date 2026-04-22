//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Виктория Юношева on 19.04.2026.
//
import Foundation

public protocol QuestionFactoryProtocol {
    func requestNextQuestion() //-> QuizQuestion?
    func reset()
    func takeAmountOfQuestions() -> Int
}

public class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    private lazy var currentRoundQuestions: [QuizQuestion] = questions
    
    init(delegate: QuestionFactoryDelegate? = nil) {
        self.delegate = delegate
    }
    
    public func requestNextQuestion() {
        guard let index = (0..<currentRoundQuestions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
           return 
        }
        
        let question = currentRoundQuestions[safe: index]
        currentRoundQuestions.remove(at: index)
        delegate?.didReceiveNextQuestion(question: question)
    }
    
    public func reset() {
        currentRoundQuestions = questions
    }
    
    public func takeAmountOfQuestions() -> Int {
        questions.count
    }
}
