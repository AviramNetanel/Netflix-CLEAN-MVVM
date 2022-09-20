//
//  ViewInstantiable.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import UIKit

// MARK: - ViewInstantiable protocol

protocol ViewInstantiable: UIView, Reusable {}

// MARK: - Default implementation

extension ViewInstantiable {
    
    static var nib: UINib { UINib(nibName: reuseIdentifier, bundle: nil) }
    
    func nibDidLoad() {
        let view = Bundle.main.loadNibNamed(String(describing: Self.self),
                                            owner: self,
                                            options: nil)![0] as! UIView
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
}

