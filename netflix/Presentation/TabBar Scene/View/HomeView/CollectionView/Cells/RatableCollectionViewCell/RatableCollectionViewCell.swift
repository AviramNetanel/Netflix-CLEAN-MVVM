//
//  RatableCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - RatableCollectionViewCell class

final class RatableCollectionViewCell: DefaultCollectionViewCell {
    
    private final class TextLayer: CATextLayer {
        override func draw(in ctx: CGContext) {
            ctx.saveGState()
            ctx.translateBy(x: 0.0, y: 0.0)
            super.draw(in: ctx)
            ctx.restoreGState()
        }
    }
    
    private let layerView = UIView()
    private var textLayer = TextLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    deinit {
        textLayer.removeFromSuperlayer()
        layerView.removeFromSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLayer.string = nil
    }
    
    private func setupViews() {
        contentView.addSubview(layerView)
        layerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            layerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            layerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            layerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            layerView.heightAnchor.constraint(equalToConstant: bounds.height / 2)
        ])
    }
    
    override func configure(with viewModel: CollectionViewCellItemViewModel) {
        super.configure(with: viewModel)
        
        self.viewModel = viewModel
        
        placeholderLabel.text = viewModel.title
        
        guard let indexPath = viewModel.indexPath as IndexPath? else { return }
        if indexPath.row == 0 {
            textLayer.frame = CGRect(x: 0.0, y: -30.0,
                                     width: bounds.width, height: 144.0)
        } else {
            textLayer.frame = CGRect(x: -8.0, y: -30.0,
                                     width: bounds.width, height: 144.0)
        }
        
        let index = "\(indexPath.row + 1)"
        let attributedString = NSAttributedString(string: index,
                                                  attributes: [.font: UIFont.systemFont(ofSize: 96.0, weight: .bold),
                                                               .strokeColor: UIColor.white,
                                                               .strokeWidth: -2.5,
                                                               .foregroundColor: UIColor.black.cgColor])
        
        layerView.layer.insertSublayer(textLayer, at: 1)
        textLayer.string = attributedString
    }
}
