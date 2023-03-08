//
//  Session.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 08/03/2023.
//

import Foundation

struct User{
    let name: String
}

class Session{
    
    static private let instance = Session()
    
    private var isAuthenticated = false
    private var user: User?
    
    // uses singleton design pattern
    private init(){}
    static func getInstance()->Session{
        instance
    }
    
    // operations
    func login(user: User){
        self.user = user
        isAuthenticated = true
    }
    func logout(){
        isAuthenticated = false
        user = nil
    }
    
    // getters
    func isUserAuthenticated()->Bool{self.isAuthenticated}
    func getUser()->User?{self.user}
}
