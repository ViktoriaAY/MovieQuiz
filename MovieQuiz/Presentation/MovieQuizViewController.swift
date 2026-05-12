import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loadAllQuestionactivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadNextQuestionactivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    
    // MARK: - Properties
    
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private var alertPresenter = ResultAlertPresenter()
    weak var delegate: QuestionFactoryDelegate?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    // MARK: - Nested Types
    
    private enum ScreenDirection {
        case forward
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuestionFactory()
        loadData()
    }
    
    private func setupQuestionFactory() {
        questionFactory = QuestionFactory(moviesLoader:  MoviesLoader(), delegate: self)
    }
    
    private func loadData() {
        showLoadingIndicator()
        questionFactory?.loadData()
        showFirstQuestion()
    }
    
    private func showFirstQuestion() {
        currentQuestionIndex = 0
        imageView.layer.cornerRadius = 20
        questionFactory?.requestNextQuestion()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
       handleAnswer(false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
     handleAnswer(true)
    }
    
    private func handleAnswer(_ givenAnswer: Bool) {
        guard let currentQuestion else {
            return
        }
        let isCorrect =
            currentQuestion.correctAnswer == givenAnswer
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
        setAnswerButtonsEnabled(false)
        
        loadNextQuestionactivityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.setAnswerButtonsEnabled(true)
        }
    }
    
    private func resetImageBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = nil
    }
    
    private func showNextQuestionOrResults() {
        resetImageBorder()
        if currentQuestionIndex ==  questionsAmount - 1 {
            statisticService.storeCurrentResult(currentResult: GameResult(
                correct: correctAnswers,
                total: questionsAmount,
                date: Date()
            ))
            let message = makeResultMessageAlert()
            show(
                quiz: .init(
                    title: "Этот раунд окончен!",
                    text: message,
                    buttonText: "Сыграть ещё раз"
                )
            )
        }
        else {
            updateViewControllerState(screenDirection: .forward)
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func updateViewControllerState(screenDirection: ScreenDirection) {
        switch screenDirection {
        case .forward:
            if currentQuestionIndex < questionsAmount - 1 {
                currentQuestionIndex += 1
            }
        }
        imageView.layer.borderWidth = 0
    }
    
    private func restartGame() {
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func makeResultMessageAlert() -> String {
        let bestGame = statisticService.bestGame
        let currentResultText = "Ваш результат: \(correctAnswers) / \(questionsAmount)"
        let gamesCountText = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let bestGameResultText = "Рекорд: \(bestGame.correct) / \(bestGame.total) (\(bestGame.date.dateTimeString))"
        let totalAccuracyText = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        return currentResultText + "\n" + gamesCountText + "\n" + bestGameResultText + "\n" + totalAccuracyText
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            restartGame()
        }
        alertPresenter.showAlert(model: model, ui: self)
    }
    
    private func setAnswerButtonsEnabled(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    private func showLoadingIndicator() {
        loadAllQuestionactivityIndicator.isHidden = false
        loadAllQuestionactivityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        loadAllQuestionactivityIndicator.stopAnimating()
        
        let model = AlertModel(title: "Что-то пошло не так(", message: message, buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            restartGame()
        }
        alertPresenter.showAlert(model: model, ui: self)
    }
}

extension MovieQuizViewController: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        loadAllQuestionactivityIndicator.stopAnimating()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        loadAllQuestionactivityIndicator.stopAnimating()
        loadNextQuestionactivityIndicator.stopAnimating()
        showNetworkError(message: "Невозможно загрузить данные")
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.loadNextQuestionactivityIndicator.stopAnimating()
            self?.show(quiz: viewModel)
        }
    }
}
