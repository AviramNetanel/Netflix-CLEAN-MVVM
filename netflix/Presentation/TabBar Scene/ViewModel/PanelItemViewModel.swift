//
//  PanelItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import Foundation

// MARK: - PanelItemViewModelInput protocol

private protocol PanelItemViewModelInput {
    var tag: Int { get }
    var isSelected: Observable<Bool> { get }
    var systemImage: String { get }
    var title: String { get }
}

// MARK: - PanelItemViewModelOutput protocol

private protocol PanelItemViewModelOutput {
    func bind(on item: DefaultPanelItemView)
}

// MARK: - PanelItemViewModel protocol

private protocol PanelItemViewModel: PanelItemViewModelInput, PanelItemViewModelOutput {}

// MARK: - DefaultPanelItemViewModel struct

struct DefaultPanelItemViewModel: PanelItemViewModel {
    
    let tag: Int
    let isSelected: Observable<Bool>
    
    var systemImage: String {
        let leading = isSelected.value ? "checkmark" : "plus"
        let trailing = "info.circle"
        return tag == 0 ? leading : trailing
    }
    
    var title: String {
        let leading = "My List"
        let trailing = "Info"
        return tag == 0 ? leading : trailing
    }
    
    init(with item: DefaultPanelItemView) {
        self.tag = item.tag
        self.isSelected = .init(item.isSelected)
        self.bind(on: item)
    }
    
    fileprivate func bind(on item: DefaultPanelItemView) {
        isSelected.observe(on: item) { _ in item.configuration?.itemDidConfigure() }
    }
}
