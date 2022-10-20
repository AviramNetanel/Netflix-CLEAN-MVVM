//
//  QoS.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - Quality of State functions

func asynchrony(_ block: @escaping () -> Void) { DispatchQueue.main.async { block() } }
