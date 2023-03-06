//
//  Environment.swift
//  TryAVPlayer
//
//  Created by magdy khalifa on 06/03/2023.
//

import Foundation

// Source
//https://www.freecodecamp.org/news/managing-different-environments-and-configurations-for-ios-projects-7970327dd9c9/

// Configurations

//(1 Add build configurations to the project
  //Debug
    // Debug and rename it as "Debug (Development)".
    // make other "Debug (Production)".

  //Release
    // release and rename it as "release (Development)".
    // make other "release (Production)".

//(2 Each build configuration need configuration file:
    //(2.1
    // create Development Configuration settings file (Development.xcconfig).
    // create Production Configuration settings file (Production.xcconfig).
    
    //(2.2
    // add environment variables to config file: (server_url = "www.google.com/production")

//(3 Assign every Build config to configuration file.
//------------------------------------------------------------------------------

// Schemes

//(4 Create 2 Schemes (Dev - Prod)
  //(4.1 Development
    // create scheme with name (Development).
    // then use Debug (Development) build configuration for build, test and analyze.
    // use Release (Develeopment) build configuration for profile, archive.

  //(4.1 Production
    // create scheme with name (Production).
    // then use Debug (Production) build configuration for build, test and analyze.
    // use Release (Production) build configuration for profile, archive.
//------------------------------------------------------------------------------

// Property lists

//(5 Make .plist files to hold configuration variables (Production.plist):
    //(5.1
    //rename info.plist to Production.plist
    //make Development.plist
    
    //(5.2
    // add plist fields for each environment: ex: server_url --> $(server_url)

//(6 Edit Target --> Build settings -> Packaging --> info.plist file --> location for each Scheme


public enum PlistKey {
    case ServerURL
    case ConnectionProtocol
    
    func value() -> String {
        switch self {
        case .ServerURL:
            return "server_url"
        case .ConnectionProtocol:
            return "protocol"
        }
    }
}
public struct Environment {
    
    fileprivate var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            }else {
                fatalError("Plist file not found")
            }
        }
    }
    public func configuration(_ key: PlistKey) -> String {
        switch key {
        case .ServerURL:
            return infoDict[PlistKey.ServerURL.value()] as! String
        case .ConnectionProtocol:
            return infoDict[PlistKey.ConnectionProtocol.value()] as! String
        }
    }
}

// MARK: Usage

print(Environment().configuration(PlistKey.ServerURL))

