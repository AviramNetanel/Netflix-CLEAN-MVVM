//
//  QoS.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

func asynchrony(_ block: @escaping () -> Void) {
    DispatchQueue.main.async { block() }
}

func asynchrony(dispatchingDelayInSeconds delay: Int, _ block: @escaping () -> Void) {
    let time = DispatchTime.now().advanced(by: .seconds(delay))
    DispatchQueue.main.asyncAfter(deadline: time, execute: block)
}
