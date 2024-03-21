//
//  ViewController.swift
//  Projects 7-9
//
//  Created by Dmitrii Vrabie on 31.01.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var scoreLabel: UILabel!
    var wrongAnswer: UILabel!
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var usedCharacters = [String]()
    var promptWord = ""
    var lives = 7 {
        didSet {
            wrongAnswer.text = "Lives: \(lives)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var answer = "LETTERS"
    var letters = ["I", "A", "N", "V", "T", "I", "A", "L", "T", "W", "E", "R", "Y", "U", "O", "P", "S", "D", "F", "G", "H", "J", "K", "Z", "E", "C", "B", "N", "M", "A"]
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        wrongAnswer = UILabel()
        wrongAnswer.translatesAutoresizingMaskIntoConstraints = false
        wrongAnswer.textAlignment = .left
        wrongAnswer.text = "Lives: 7"
        view.addSubview(wrongAnswer)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Win: 0"
        view.addSubview(scoreLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 24)
        currentAnswer.isUserInteractionEnabled = false
        currentAnswer.layer.borderWidth = 1
        currentAnswer.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(currentAnswer)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            
            wrongAnswer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            wrongAnswer.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 250),
            buttonsView.heightAnchor.constraint(equalToConstant: 400),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),

        ])
        
        let width = 50
        let height = 50
        
        for row in 0..<6 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
                letterButton.setTitle("W", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showWord()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        usedCharacters.append(buttonTitle)
        if answer.contains(buttonTitle) {
            sender.isHidden = true
        } else {
            sender.isEnabled = false
            sender.titleLabel?.textColor = .red
            lives -= 1
            showError()
        }
        showWord()
        
        activatedButtons.append(sender)
    }
    
    func showWord() {
        var newPromptWord = promptWord
        for character in answer {
            let stringCharacter = String(character)
            if usedCharacters.contains(stringCharacter) {
                newPromptWord += stringCharacter
            } else {
                newPromptWord += "?"
            }
        }
        
        if !newPromptWord.contains("?") {
            score += 1
        }
        
        self.currentAnswer.text = newPromptWord.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if letters.count == self.letterButtons.count {
            for i in 0 ..< self.letterButtons.count {
                self.letterButtons[i].setTitle(letters[i], for: .normal)
            }
        }
    }
    func showError() {
        if lives == 0 {
            let ac = UIAlertController(title: "You lose", message: "Keep trying!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: restartGame))
            present(ac, animated: true)
        }
    }
    func restartGame(action: UIAlertAction) {
        lives = 7
        score = 0
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
        usedCharacters.removeAll()
        showWord()
        
    }
}
