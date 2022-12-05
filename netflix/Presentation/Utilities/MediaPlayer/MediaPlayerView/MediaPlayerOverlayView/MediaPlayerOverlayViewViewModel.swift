//
//  MediaPlayerOverlayViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 10/10/2022.
//

import Foundation

// MARK: - MediaPlayerOverlayViewViewModel struct

struct MediaPlayerOverlayViewViewModel {
    
    let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
    
    func timeString(_ time: Float) -> String {
        let components = NSDateComponents()
        components.second = Int(max(.zero, time))
        return timeRemainingFormatter.string(for: components as DateComponents)!
    }
}
