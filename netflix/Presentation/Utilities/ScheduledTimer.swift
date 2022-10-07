//
//  ScheduledTimer.swift
//  netflix
//
//  Created by Zach Bazov on 06/10/2022.
//

import Foundation

// MARK: - ScheduleInput protocol

private protocol ScheduleInput {
    func schedule(timeInterval: TimeInterval,
                  target: Any,
                  selector: Selector,
                  repeats: Bool)
    func invalidate()
}

// MARK: - ScheduleOutput protocol

private protocol ScheduleOutput {
    var timer: Timer! { get }
}

// MARK: - Schedule typealias

private typealias Schedule = ScheduleInput & ScheduleOutput

// MARK: - ScheduledTimer class

final class ScheduledTimer: Schedule {
    
    var timer: Timer!
    
    deinit { timer = nil }
    
    func schedule(timeInterval: TimeInterval,
                  target: Any,
                  selector: Selector,
                  repeats: Bool) {
        invalidate()
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: target,
                                     selector: selector,
                                     userInfo: nil,
                                     repeats: repeats)
    }
    
    func invalidate() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
}
