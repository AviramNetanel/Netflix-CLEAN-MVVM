//
//  QoS.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

func asynchrony(_ block: @escaping () -> Void) { DispatchQueue.main.async { block() } }
