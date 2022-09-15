//
//  PanelView.swift
//  netflix
//
//  Created by Zach Bazov on 10/09/2022.
//

import UIKit

// MARK: - PanelView class

final class PanelView: UIView, Reusable {
    
    private var viewModel: DefaultHomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    deinit {
        viewModel = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: DefaultHomeViewModel) -> PanelView {
        let view = PanelView.nib.instantiateSubview(onParent: parent) as! PanelView
        view.viewModel = viewModel
        view.constraint(to: parent)
        return view
    }
    
    private func constraint(to parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 64.0)
        ])
    }
    
    private func setupViews() {
        print("setupss panelview")
    }
}
