//
//  AppConfiguration.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

final class AppConfiguration {
    
    lazy var apiScheme: String = {
        guard let scheme = Bundle.main.object(forInfoDictionaryKey: "API Scheme") as? String else {
            fatalError("API Scheme must be set on the property list file.")
        }
        return scheme
    }()
    
    lazy var apiHost: String = {
        guard let host = Bundle.main.object(forInfoDictionaryKey: "API Host") as? String else {
            fatalError("API Host must be set on the property list file.")
        }
        return host
    }()
}
