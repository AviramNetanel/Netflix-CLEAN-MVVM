//
//  PanelView.swift
//  netflix
//
//  Created by Zach Bazov on 10/09/2022.
//

import UIKit

final class PanelView: UIView, ViewInstantiable {
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private(set) weak var leadingItemViewContainer: UIView!
    @IBOutlet private(set) weak var trailingItemViewContainer: UIView!
    
    private var viewModel: DisplayTableViewCellViewModel!
    fileprivate(set) var leadingItemView: PanelViewItem!
    fileprivate(set) var trailingItemView: PanelViewItem!
    
    init(on parent: UIView, with viewModel: DisplayTableViewCellViewModel) {
        self.viewModel = viewModel
        super.init(frame: parent.bounds)
        self.nibDidLoad()
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.leadingItemView = PanelViewItem(on: self.leadingItemViewContainer, with: viewModel)
        self.trailingItemView = PanelViewItem(on: self.trailingItemViewContainer, with: viewModel)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        leadingItemView = nil
        trailingItemView = nil
    }
    
    fileprivate func viewDidConfigure() {
        playButton.layer.cornerRadius = 6.0
        playButton.addTarget(self, action: #selector(playDidTap), for: .touchUpInside)
    }
    
    @objc
    fileprivate func playDidTap() {
        let section = viewModel.sectionAt(.display)
        let media = viewModel.presentedDisplayMedia.value!
        viewModel.actions?.presentMediaDetails(section, media)
        
        DeviceOrientation.shared.orientation = .landscapeRight
    }
    
    func removeObservers() {
        printIfDebug("Removed `PanelView` observers.")
        leadingItemView.viewModel.removeObservers()
        trailingItemView.viewModel.removeObservers()
    }
}
