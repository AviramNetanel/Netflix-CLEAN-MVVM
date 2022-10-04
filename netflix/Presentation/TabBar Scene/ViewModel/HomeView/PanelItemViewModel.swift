//
//  PanelItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    var tag: Int { get }
    var isSelected: Observable<Bool> { get }
    var systemImage: String { get }
    var title: String { get }
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {
    func bind(on item: PanelViewItem)
}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - PanelItemViewModel class

final class PanelItemViewModel: ViewModel {
    
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
    
    init(with item: PanelViewItem) {
        self.tag = item.tag
        self.isSelected = .init(item.isSelected)
        self.bind(on: item)
    }
    
    fileprivate func bind(on item: PanelViewItem) {
        isSelected.observe(on: self) { _ in item.configuration?.itemDidConfigure() }
    }
    
    func removeObservers() {
        isSelected.remove(observer: self)
    }
}
