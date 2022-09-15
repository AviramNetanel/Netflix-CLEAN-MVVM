//
//  DefaultPanelItemView.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - PanelItemViewConfiguration protocol

private protocol PanelItemViewConfiguration {
    
}

// MARK: - DefaultPanelItemViewConfiguration struct

struct DefaultPanelItemViewConfiguration {
    
    enum GestureGecognizer {
        case tap
        case longPress
    }
    
    enum Item: Int {
        case myList
        case info
    }
    
    let gestureRecognizers: [GestureGecognizer]
    let items: [Item]
    
    var tapRecognizer: UITapGestureRecognizer!
    var longPressRecognizer: UILongPressGestureRecognizer!
}

// MARK: - PanelItemViewInput protocol

private protocol PanelItemViewInput {
    
}

// MARK: - PanelItemViewOutput protocol

private protocol PanelItemViewOutput {
    
}

// MARK: - PanelItemView protocol

private protocol PanelItemView: PanelItemViewInput, PanelItemViewOutput {}

// MARK: - DefaultPanelItemView class

final class DefaultPanelItemView: UIView, PanelItemView, ViewInstantiable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    var configuration: DefaultPanelItemViewConfiguration?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nibDidLoad()
        self.configuration = .init(gestureRecognizers: [.tap, .longPress],
                                   items: [.myList, .info])
    }
}

