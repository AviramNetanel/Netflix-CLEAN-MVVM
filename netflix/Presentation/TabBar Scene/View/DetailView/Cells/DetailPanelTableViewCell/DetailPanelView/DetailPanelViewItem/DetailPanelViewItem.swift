//
//  DetailPanelViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - ConfigurationInput protocol

@objc
private protocol ConfigurationInput {
    func viewDidConfigure()
    func viewDidRegisterRecognizers()
    func viewDidTap()
    func selectIfNeeded()
}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {
    var view: DetailPanelViewItem! { get }
}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - DetailPanelViewItemConfiguration class

final class DetailPanelViewItemConfiguration: Configuration {
    
    enum Item: Int {
        case myList
        case rate
        case share
    }
    
    fileprivate weak var view: DetailPanelViewItem!
    fileprivate let myList: MyList
    fileprivate let section: Section
    
    init(view: DetailPanelViewItem, with viewModel: DetailViewModel) {
        self.view = view
        self.myList = viewModel.myList
        self.section = viewModel.myListSection
        self.viewDidConfigure()
        self.viewDidRegisterRecognizers()
    }
    
    deinit { view = nil }
    
    fileprivate func viewDidRegisterRecognizers() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    fileprivate func selectIfNeeded() {
        guard let tag = Item(rawValue: view.tag) else { return }
        if case .myList = tag {
            view.viewModel.isSelected.value = myList.contains(
                view.viewModel.media,
                in: section.media)
        }
    }
    
    func viewDidConfigure() {
        view.imageView.image = UIImage(systemName: view.viewModel.systemImage)?.whiteRendering()
        view.label.text = view.viewModel.title
        
        selectIfNeeded()
    }
    
    func viewDidTap() {
        guard let tag = Item(rawValue: view.tag) else { return }
        
        switch tag {
        case .myList:
            let media = view.viewModel.media!
            if myList.list.value.isEmpty {
                myList.createList()
            }
            myList.shouldAddOrRemove(
                media,
                uponSelection: view.viewModel.isSelected.value)
        case .rate: print("rate")
        case .share: print("share")
        }
        
        view.setAlphaAnimation(using: view.gestureRecognizers!.first) { [weak self] in
            self?.view.viewModel.isSelected.value.toggle()
        }
    }
}

//// MARK: - ViewInput protocol
//
//private protocol ViewInput {}
//
//// MARK: - ViewOutput protocol
//
//private protocol ViewOutput {
//    var configuration: DetailPanelViewItemConfiguration! { get }
//    var viewModel: DetailPanelViewItemViewModel! { get }
//    var isSelected: Bool { get }
//}
//
//// MARK: - View typealias
//
//private typealias View = ViewInput & ViewOutput

// MARK: - DetailPanelViewItem class

final class DetailPanelViewItem: UIView {
    
    fileprivate(set) var configuration: DetailPanelViewItemConfiguration!
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
