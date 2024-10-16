import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresentDelegate {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresentProtocol?
    private var statisticService: StatisticServiceProtocol?
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        statisticService = StatisticService()
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        showLoadingIndicator()
        questionFactory.loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresentDelegate
    
    func makeAlertModel() -> AlertModel {
        self.imageView.layer.borderWidth = 0
        
        let result = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: """
        Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
        Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0 )
        Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(presenter.questionsAmount) (\(statisticService?.bestGame.date.dateTimeString ?? " "))
        Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%
        """,
            buttonText: "Сыграть еще раз")
        
        let alert = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText) { [weak self] in
                self?.restartGame()
            }
        return alert
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        getCorrectAnswer(userAnswer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        getCorrectAnswer(userAnswer: true)
    }
}

// MARK: - Private Methods
private extension MovieQuizViewController {
    
    func setupLayout() {
        noButton.layer.cornerRadius = 15
        yesButton.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 20
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func getCorrectAnswer(userAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let isCorrect = userAnswer == currentQuestion.correctAnswer
        
        showAnswerResult(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            alertPresenter?.showAlert(alertModel: makeAlertModel())
        } else {
            presenter.switchToNextQuestion()
            imageView.layer.borderWidth = 0
            questionFactory?.requestNextQuestion()
        }
        
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func restartGame() {
        presenter.resetQuestionIndex()
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        
        let alert = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                self?.restartGame()
            }
        alertPresenter?.showAlert(alertModel: alert)
    }
}
