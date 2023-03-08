//
//  Prototype.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 08/03/2023.
//

import Foundation

//https://drive.google.com/file/d/1CnIR1YFGuSaCLZpoQh2FP0ekwOdJh4ej/view?usp=sharing

protocol Clonable{
    func clone()->Clonable
}

class Person: Clonable{
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    // custom initialser
    init(other: Person){
        self.name = other.name
        self.age = other.age
    }
    
    // returns a clone from self
    func clone() -> Clonable {
        Person(other: self)
    }
}
