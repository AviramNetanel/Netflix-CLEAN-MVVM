//
//  PanelViewItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import Foundation

final class PanelViewItemViewModel {
    let tag: Int
    let isSelected: Observable<Bool>
    let media: Media!
    
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
    
    init(item: PanelViewItem, with media: Media) {
        self.tag = item.tag
        self.isSelected = .init(item.isSelected)
        self.media = media
        self.bind(on: item)
    }
    
    fileprivate func bind(on item: PanelViewItem) {
        isSelected.observe(on: self) { _ in item.configuration?.viewDidConfigure() }
    }
    
    func removeObservers() {
        isSelected.remove(observer: self)
    }
}
