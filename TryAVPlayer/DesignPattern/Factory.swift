//
//  Factory.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 08/03/2023.
//

import Foundation
// Protocol
protocol Vehicle{
    var type: VehicleType {get}
    func drive()
}
extension Vehicle{
    func drive(){
        print("Driving a \(type)")
    }
}

// Different classes
class Car: Vehicle{
    var type: VehicleType = .car
}

class Bus: Vehicle{
    var type: VehicleType = .bus
}

class Tractor: Vehicle{
    var type: VehicleType = .tractor
}

enum VehicleType: String{
    case car
    case bus
    case tractor
}

// Factory
class VehicleFactory{
    
    func createVehicle(type: VehicleType)->Vehicle{
        switch type {
        case .car:
            return Car()
        case .bus:
            return Bus()
        case .tractor:
            return Bus()
        }
    }
    
}
