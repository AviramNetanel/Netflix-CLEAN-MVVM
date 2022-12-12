//
//  DetailPanelTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class DetailPanelTableViewCell: UITableViewCell {
    var panelView: DetailPanelView!
    
    init(with viewModel: DetailViewModel) {
        super.init(style: .default, reuseIdentifier: DetailPanelTableViewCell.reuseIdentifier)
        self.panelView = DetailPanelView(on: self.contentView, with: viewModel)
        self.contentView.addSubview(self.panelView)
        self.viewDidConfigure()
    }
    
    deinit {
        panelView = nil
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func viewDidConfigure() {
        backgroundColor = .black
        selectionStyle = .none
    }
}
