//
//  UINib+Extension.swift
//  netflix
//
//  Created by Zach Bazov on 10/09/2022.
//

import UIKit

// MARK: - UINib + Instantiate Subview

extension UINib {
    func instantiateSubview(onParent parent: UIView) -> UIView {
        let view = instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = parent.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        parent.addSubview(view)
        return view
    }
}
