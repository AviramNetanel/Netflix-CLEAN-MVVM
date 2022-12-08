//
//  DetailPanelViewItemViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import Foundation

final class DetailPanelViewItemViewModel {
    let tag: Int
    let isSelected: Observable<Bool>
    var media: Media!
    
    var systemImage: String {
        guard let tag = DetailPanelViewItemConfiguration.Item(rawValue: tag) else { fatalError() }
        switch tag {
        case .myList: return isSelected.value ? "checkmark" : "plus"
        case .rate: return isSelected.value ? "hand.thumbsup.fill" : "hand.thumbsup"
        case .share: return "square.and.arrow.up"
        }
    }
    
    var title: String {
        guard let tag = DetailPanelViewItemConfiguration.Item(rawValue: tag) else { fatalError() }
        switch tag {
        case .myList: return "My List"
        case .rate: return "Rate"
        case .share: return "Share"
        }
    }
    
    init(item: DetailPanelViewItem,
         with viewModel: DetailViewModel) {
        self.tag = item.tag
        self.isSelected = Observable(item.isSelected)
        self.media = viewModel.media
        self.observe(on: item)
    }
    
    private func observe(on item: DetailPanelViewItem) {
        isSelected.observe(on: self) { _ in
            item.configuration?.viewDidConfigure()
        }
    }
    
    func removeObservers() {
        isSelected.remove(observer: self)
    }
}
