//
//  PanelView.swift
//  netflix
//
//  Created by Zach Bazov on 10/09/2022.
//

import UIKit

// MARK: - PanelView class

final class PanelView: UIView {
    
    private var viewModel: HomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    deinit {
        viewModel = nil
    }
    
    static func create(onParent parent: UIView,
                       with viewModel: HomeViewModel) -> PanelView {
        let view = PanelView.nib.instantiateSubview(onParent: parent) as! PanelView
        view.viewModel = viewModel
        return view
    }
    
    func constraint(toParent parent: UIView) -> PanelView {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 64.0)
        ])
        return self
    }
    
    private func setupViews() {
        print("setup")
    }
}

// MARK: - Configurable implementation

extension PanelView: Configurable {}
