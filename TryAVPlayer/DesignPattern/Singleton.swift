//
//  Singleton.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 08/03/2023.
//

import UIKit

//https://drive.google.com/file/d/1CnIR1YFGuSaCLZpoQh2FP0ekwOdJh4ej/view?usp=sharing

class PlayerSingleton{
    var name = "mido"
    
    private static var instance = PlayerSingleton()
    
    private init(){
        // private initialiser to prevent instantiation outside this class
    }
    
    static func getInstance()->PlayerSingleton{instance}
}

class UseInstance{
    
    weak var playerSingleton = PlayerSingleton.getInstance()
}
