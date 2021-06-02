//
//  ViewController.swift
//  calculator
//
//  Created by Илья Москалев on 13.04.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var displayResultLabel: UILabel!
    
    var stillTyping = false
    
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operationSign: String = ""
    var hasComma = false
    
    var currentInput: Double {
        get {
            return Double(displayResultLabel.text!)!
        } set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                displayResultLabel.text = valueArray[0]
            } else {
            displayResultLabel.text = "\(newValue)"
        }
            stillTyping = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func numberPressed(_ sender: UIButton) {
        let number = sender.currentTitle!
        
        if stillTyping {
            if displayResultLabel.text!.count < 20 {
            displayResultLabel.text = displayResultLabel.text! + number
            }
        } else {
            displayResultLabel.text = number
            stillTyping = true
        }
    }
    @IBAction func twoOperandsSignPressed(_ sender: UIButton) {
        operationSign = sender.currentTitle!
        
        firstOperand = currentInput
        stillTyping = false
        hasComma = false
    }
    
    func operateWithTwoOperands(operation: (Double, Double) -> Double) {
        currentInput = operation(firstOperand, secondOperand)
        stillTyping = false
    }
    
    @IBAction func equalitySignPressed(_ sender: Any) {
        if stillTyping {
            secondOperand = currentInput
        }
        hasComma = false
        
        print("\(firstOperand) \(secondOperand) \(operationSign)")
        
        switch operationSign {
        case "+":
            operateWithTwoOperands{$0 + $1}
        case "-":
            operateWithTwoOperands{$0 - $1}
        case "x":
            operateWithTwoOperands{$0 * $1}
        case "/":
            operateWithTwoOperands{$0 / $1}
        default: break
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        displayResultLabel.text = "0"
        stillTyping = false
        operationSign = ""
        hasComma = false
        
    }
    
    @IBAction func changeSign(_ sender: UIButton) {
        currentInput = -currentInput
    }
    
    @IBAction func percent(_ sender: UIButton) {
        if firstOperand == 0 {
            currentInput = currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput / 100
        }
        stillTyping = false
    }
    
    @IBAction func comma(_ sender: UIButton) {
        if !hasComma && stillTyping {
            displayResultLabel.text = displayResultLabel.text! + "."
            hasComma = true
        } else if !stillTyping && !hasComma {
            displayResultLabel.text = "0."
        }
    }
    
}

