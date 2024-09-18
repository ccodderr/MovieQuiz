import UIKit

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var playedQuizCount = 0
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "TheGodfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "TheDarkKnight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "KillBill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "TheAvengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "TheGreenKnight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true
        ),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "TheIceAgeAdventuresOfBuckWild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        ),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false
        )
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        let currentQuestion = questions[currentQuestionIndex]
        let currentStep = convert(model: currentQuestion)
        show(quiz: currentStep)
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
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.layer.cornerRadius = 15
        yesButton.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 20
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func getCorrectAnswer(userAnswer: Bool) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = userAnswer == currentQuestion.correctAnswer
        
        showAnswerResult(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
    }
    
    func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            playedQuizCount += 1
            showAlert()
        } else {
            currentQuestionIndex += 1
            
            imageView.layer.borderWidth = 0
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    func showAlert() {
        let message = "Ваш результат: \(correctAnswers)/10 \nКоличество сыгранных квизов: \(playedQuizCount)"
        let alert = UIAlertController(
            title: "Этот раунд окончен!",
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "Сыграть еще раз",
            style: .default
        ) { _ in
            self.currentQuestionIndex = 0
            self.imageView.layer.borderWidth = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let firstStep = self.convert(model: firstQuestion)
            
            self.show(quiz: firstStep)
          }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
