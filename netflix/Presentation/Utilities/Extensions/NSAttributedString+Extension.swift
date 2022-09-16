//
//  NSAttributedString+Extension.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - NSAttributedString + Attributes

extension NSAttributedString {
    static let placeholderAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                                                                       .foregroundColor: UIColor.white]
}
