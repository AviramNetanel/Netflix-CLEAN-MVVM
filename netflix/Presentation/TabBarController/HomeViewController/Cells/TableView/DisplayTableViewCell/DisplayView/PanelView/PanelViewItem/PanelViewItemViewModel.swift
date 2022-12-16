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
    var media: Media!
    
    var systemImage: String {
        let leading = isSelected.value ? "checkmark" : "plus"
        let trailing = "info.circle"
        return tag == 0 ? leading : trailing
    }
    
    var title: String {
        let leadingTitle = Localization.TabBar.Home.Panel().leadingTitle
        let trailingTitle = Localization.TabBar.Home.Panel().trailingTitle
        let leading = leadingTitle
        let trailing = trailingTitle
        return tag == 0 ? leading : trailing
    }
    
    init(item: PanelViewItem, with media: Media) {
        self.tag = item.tag
        self.isSelected = .init(item.isSelected)
        self.media = media
        self.bind(on: item)
    }
    
    deinit {
        media = nil
    }
    
    fileprivate func bind(on item: PanelViewItem) {
        isSelected.observe(on: self) { _ in item.configuration?.viewDidConfigure() }
    }
    
    func removeObservers() {
        isSelected.remove(observer: self)
    }
}
