//
//  CalculatorBrain.swift
//  Calculator_Assignment_1
//
//  Created by LinSP on 2017/3/3.
//  Copyright © 2017年 LinSP. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    private var accumulator: Double?
    
    var discription: String = ""
    private var discriptionPriority = 0
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private let operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "±": Operation.unaryOperation({-$0}),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "√": Operation.unaryOperation(sqrt),
        "+": Operation.binaryOperation({$0 + $1}),
        "-": Operation.binaryOperation({$0 - $1}),
        "×": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "=": Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                discription += symbol
                discriptionPriority = 1
            case .unaryOperation(let function):
                if accumulator != nil {
                    if resultIsPending {
                        let range = discription.index(discription.endIndex, offsetBy: -3) ..< discription.endIndex
                        discription.removeSubrange(range)
                        discription += symbol + "(\(accumulator!))"
                    } else {
                        discription = symbol + "(\(discription))"
                    }
                    discriptionPriority = 3
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    var selfPriority: Int {
                        get {
                            if symbol == "+" || symbol == "-" {
                                return 1
                            } else {
                                return 2
                            }
                        }
                    }
                    if discriptionPriority < selfPriority {
                        discription = "(\(discription))" + symbol
                    } else {
                        discription += symbol
                    }
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            //discription += "\(accumulator!)"
            accumulator = pendingBinaryOperation!.performBinaryOperation(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        var function: (Double, Double) -> Double
        var firstOperand: Double
        
        func performBinaryOperation(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        discription += "\(accumulator!)"
        discriptionPriority = 1
    }
    
    mutating func clean() {
        accumulator = nil
        pendingBinaryOperation = nil
        discription = ""
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
