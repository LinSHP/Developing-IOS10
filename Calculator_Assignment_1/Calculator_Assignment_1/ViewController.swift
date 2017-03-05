//
//  ViewController.swift
//  Calculator_Assignment_1
//
//  Created by LinSP on 2017/3/3.
//  Copyright © 2017年 LinSP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var discription: UILabel!
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle
        if !userIsInTheMiddleOfTyping {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        } else {
            if digit != "." || !(display.text!.contains(".")){
                display.text = display.text! + digit!
            }
        }
    }
    
    var calculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        let symbol = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            calculatorBrain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        calculatorBrain.performOperation(symbol)
        if let result = calculatorBrain.result {
            displayValue = result
        }
        if calculatorBrain.resultIsPending {
            discription.text = calculatorBrain.discription + "..."
        } else {
            discription.text = calculatorBrain.discription + "="
        }
    }
    
    @IBAction func cleanCalculator() {
        display.text = "0"
        userIsInTheMiddleOfTyping = false
        discription.text = " "
        calculatorBrain.clean()
    }
}

