//
//  Decorator.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 08/03/2023.
//

import Foundation

// https://vinileal.com/design%20patterns/design-patterns-swift-decorator/
// allows you to add new functionality or modify existing behavior of an object by wrapping it with one or more decorator objects
protocol SalaryCalculator {
    func calculateSalary(hourlyRate: Double) -> Double
}

// base client
class ExampleSalaryCalculator: SalaryCalculator {
    func calculateSalary(hourlyRate: Double) -> Double {
        hourlyRate * 40 * 5
    }
}

// and can add new behavior by implementing the same interface as the original object.

// Decorators
class TaxDiscountSalaryDecorator: SalaryCalculator {
    let decoratee: SalaryCalculator
    
    init(_ decoratee: SalaryCalculator) {
        self.decoratee = decoratee
    }
    
    func calculateSalary(hourlyRate: Double) -> Double {
        applyDiscount(decoratee.calculateSalary(hourlyRate: hourlyRate))
    }
    
    private func applyDiscount(_ baseSalary: Double) -> Double {
        baseSalary - (baseSalary * 0.15)
    }
}

class HealthCareDiscountSalaryDecorator: SalaryCalculator {
    let decoratee: SalaryCalculator
    
    init(_ decoratee: SalaryCalculator) {
        self.decoratee = decoratee
    }
    
    func calculateSalary(hourlyRate: Double) -> Double {
        applyDiscount(decoratee.calculateSalary(hourlyRate: hourlyRate))
    }
    
    private func applyDiscount(_ baseSalary: Double) -> Double {
        baseSalary - 600
    }
}


//MARK: Usage

// original
let originalSalarycalculator = ExampleSalaryCalculator()

// setup wrappers
let healthAndTaxSalaryCalculator = HealthCareDiscountSalaryDecorator(TaxDiscountSalaryDecorator(originalSalarycalculator))

// now wrap orginal with salary wrappers
healthAndTaxSalaryCalculator.calculateSalary(hourlyRate: 40)
