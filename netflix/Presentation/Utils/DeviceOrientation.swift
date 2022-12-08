//
//  DeviceOrientation.swift
//  netflix
//
//  Created by Zach Bazov on 03/12/2022.
//

import UIKit.UIApplication

final class DeviceOrientation {
    static let shared = DeviceOrientation()
    
    var orientationLock: UIInterfaceOrientationMask = .all
    
    var orientation: UIInterfaceOrientationMask = .portrait {
        didSet { set(orientation: orientation) }
    }
    
    private let orientationKey = "orientation"
    private var windowScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    private init() {}
    
    func set(orientation: UIInterfaceOrientationMask) {
        if #available(iOS 16.0, *) {
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
            return
        }
        
        UIDevice.current.setValue(orientation.rawValue, forKey: orientationKey)
    }
}
