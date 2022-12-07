//
//  DetailPanelTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class DetailPanelTableViewCell: UITableViewCell {
    fileprivate(set) var panelView: DetailPanelView!
    
    deinit { panelView = nil }
    
    init(with viewModel: DetailViewModel) {
        super.init(style: .default, reuseIdentifier: DetailPanelTableViewCell.reuseIdentifier)
        self.panelView = DetailPanelView(on: self.contentView, with: viewModel)
        self.contentView.addSubview(self.panelView)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
