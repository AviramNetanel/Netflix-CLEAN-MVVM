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
    
    static func instantiateSubview(onParent parent: UIView) -> UIView {
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = parent.bounds
        parent.addSubview(view)
        return view
    }
    
    func nibDidLoad() {
        let view = Bundle.main.loadNibNamed(String(describing: Self.self),
                                            owner: self,
                                            options: nil)![0] as! UIView
        addSubview(view)
    }
}

