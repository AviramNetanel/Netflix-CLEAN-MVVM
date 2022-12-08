//
//  DetailPanelViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

final class DetailPanelViewItemConfiguration {
    enum Item: Int {
        case myList
        case rate
        case share
    }
    
    private weak var view: DetailPanelViewItem!
    private let myList: MyList
    private let section: Section
    
    init(view: DetailPanelViewItem, with viewModel: DetailViewModel) {
        self.view = view
        self.myList = viewModel.myList
        self.section = viewModel.myListSection
        self.viewDidConfigure()
        self.viewDidRegisterRecognizers()
    }
    
    deinit {
        view = nil
    }
    
    private func viewDidRegisterRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    private func selectIfNeeded() {
        guard let tag = Item(rawValue: view.tag) else { return }
        if case .myList = tag {
            view.viewModel.isSelected.value = myList.viewModel.contains(
                view.viewModel.media,
                in: section.media)
        }
    }
    
    func viewDidConfigure() {
        view.imageView.image = UIImage(systemName: view.viewModel.systemImage)?.whiteRendering()
        view.label.text = view.viewModel.title
        
        selectIfNeeded()
    }
    
    @objc
    func viewDidTap() {
        guard let tag = Item(rawValue: view.tag) else { return }
        
        switch tag {
        case .myList:
            if myList.viewModel.list.value.isEmpty {
                myList.viewModel.createList()
            }
            
            let media = view.viewModel.media!
            myList.viewModel.shouldAddOrRemove(media, uponSelection: view.viewModel.isSelected.value)
        case .rate: print("rate")
        case .share: print("share")
        }
        
        view.setAlphaAnimation(using: view.gestureRecognizers!.first) { [weak self] in
            self?.view.viewModel.isSelected.value.toggle()
        }
    }
}

final class DetailPanelViewItem: UIView {
    private(set) var configuration: DetailPanelViewItemConfiguration!
    var viewModel: DetailPanelViewItemViewModel!
    
    fileprivate lazy var imageView = createImageView()
    fileprivate lazy var label = createLabel()
    
    var isSelected = false
    
    init(on parent: UIView, with viewModel: DetailViewModel) {
        super.init(frame: parent.bounds)
        self.tag = parent.tag
        parent.addSubview(self)
        self.chainConstraintToCenter(linking: self.imageView, to: self.label)
        self.viewModel = DetailPanelViewItemViewModel(item: self, with: viewModel)
        self.configuration = DetailPanelViewItemConfiguration(view: self, with: viewModel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        configuration = nil
        viewModel = nil
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        label.textAlignment = .center
        addSubview(label)
        return label
    }
    
    private func createImageView() -> UIImageView {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.image = image.whiteRendering()
        addSubview(imageView)
        return imageView
    }
}
