//
//  MediaPlayerObservers.swift
//  netflix
//
//  Created by Zach Bazov on 10/10/2022.
//

import Foundation
import Combine

// MARK: - ObserverInput protocol

private protocol ObserverInput {}

// MARK: - ObserverOutput protocol

protocol ObserverOutput {
    var timeObserverToken: Any! { get set }
    var playerItemStatusObserver: NSKeyValueObservation! { get set }
    var playerItemFastForwardObserver: NSKeyValueObservation! { get set }
    var playerItemReverseObserver: NSKeyValueObservation! { get set }
    var playerItemFastReverseObserver: NSKeyValueObservation! { get set }
    var playerTimeControlStatusObserver: NSKeyValueObservation! { get set }
    var playerItemDidEndPlayingObserver: AnyCancellable! { get set }
    var cancelBag: Set<AnyCancellable>! { get set }
}

// MARK: - Observer typealias

private typealias Observer = ObserverInput & ObserverOutput

// MARK: - MediaPlayerObservers struct

struct MediaPlayerObservers: Observer {
    var timeObserverToken: Any!
    var playerItemStatusObserver: NSKeyValueObservation!
    var playerItemFastForwardObserver: NSKeyValueObservation!
    var playerItemReverseObserver: NSKeyValueObservation!
    var playerItemFastReverseObserver: NSKeyValueObservation!
    var playerTimeControlStatusObserver: NSKeyValueObservation!
    var playerItemDidEndPlayingObserver: AnyCancellable!
    var cancelBag: Set<AnyCancellable>!
}
