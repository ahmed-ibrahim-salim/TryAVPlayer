//
//  Observer.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 08/03/2023.
//

import Foundation

// Observable
protocol Subject{
    func registerObserver(observer: Observer)
    func removeObserver(observer: Observer)
    func notify()
}

// listener
protocol Observer{
    var id: String {get}
    func update(price: Double)
}

// Broadcast
class StockPriceBroadcast: Subject{
    private var observers: [Observer] = []
    private var price: Double = 0.0
    
    init(){
        updatePriceWithTimer()
    }
    func registerObserver(observer: Observer) {
        
        if let _ = observers.firstIndex(where: {$0.id == observer.id}){
            print("observer with id \(observer.id) is already listening")
        }else{
            observers.append(observer)

            print("observer with id \(observer.id) is added to listeners")
        }
    }
    
    func removeObserver(observer: Observer) {
        
        if let indexOfObserver = observers.firstIndex(where: {$0.id == observer.id}){
            observers.remove(at: indexOfObserver)
            print("observer with id \(observer.id) was removed")
        }else{
            print("observer with id \(observer.id) is not found")
        }
    }
    
    func notify() {
        observers.forEach({$0.update(price: price)})
    }
    
    // calling with timer
    private func updatePriceWithTimer(){
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updatePrice), userInfo: nil, repeats: true)
    }
    
    @objc func updatePrice(){
        price += 2.0
        notify()
    }
}

// Observer implementation
class StockPriceObserver: Observer{
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    func update(price: Double) {
        print("Observer with \(id) was notified of the new price \(price)")
    }
    
}
