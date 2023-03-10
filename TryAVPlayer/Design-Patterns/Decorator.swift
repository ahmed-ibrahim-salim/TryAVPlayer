//
//  Decorator.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 08/03/2023.
//

import Foundation

// https://medium.com/swiftcraft/swift-solutions-decorator-pattern-49fcfb18c1ce

// using a protocol to use all classes interchangebly (indistinguishable)
protocol Transporting {
  func getSpeed() -> Double
  func getTraction() -> Double
}

// Core object to decorate
final class RaceCar: Transporting {
  private let speed = 10.0
  private let traction = 10.0
  
  func getSpeed() -> Double {
    return speed
  }
  
  func getTraction() -> Double {
    return traction
  }
}

// Abstract Decorator, which injects Core object RaceCar
class TireDecorator: Transporting {
  // 1
  private let transportable: Transporting
  
  init(transportable: Transporting) {
    self.transportable = transportable
  }
  
  // 2
  func getSpeed() -> Double {
    return transportable.getSpeed()
  }
  
  func getTraction() -> Double {
    return transportable.getTraction()
  }
}

//
// first decorator
class OffRoadTireDecorator: Transporting {
  private let transportable: Transporting
  
  init(transportable: Transporting) {
    self.transportable = transportable
  }
  
  func getSpeed() -> Double {
    return transportable.getSpeed() - 3.0
  }
  
  func getTraction() -> Double {
    return transportable.getTraction() + 3.0
  }
}

// other decorator that also can inject a decorator
class ChainedTireDecorator: Transporting {
  private let transportable: Transporting
  
  init(transportable: Transporting) {
    self.transportable = transportable
  }
  
  func getSpeed() -> Double {
    return transportable.getSpeed() - 1.0
  }
  
  func getTraction() -> Double {
    return transportable.getTraction() * 1.1
  }
}


