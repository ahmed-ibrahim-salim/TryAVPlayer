//
//  Errors.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 07/03/2023.
//

import Foundation

enum Errors: Int, CustomStringConvertible{
    
    // init with int code
    case status401 = 401
    case status403 = 403
    case status404 = 404
    
    // get message for each status code
    var description: String {
        switch self {
        case .status401:
            return "401 not authorised"
        case .status403:
            return "403 not authenticated"
        case .status404:
            return "404 page not found"
        }
    }
}


