//
//  ViewInstantiable.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import UIKit

// MARK: - ViewInstantiable protocol

protocol ViewInstantiable: UIView {}

// MARK: - Default implementation

extension ViewInstantiable {
    func nibDidLoad() {
        let view = Bundle.main.loadNibNamed(String(describing: Self.self),
                                            owner: self,
                                            options: nil)![0] as! UIView
        addSubview(view)
    }
}

