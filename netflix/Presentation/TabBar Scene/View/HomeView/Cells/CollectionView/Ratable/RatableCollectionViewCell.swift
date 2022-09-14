//
//  RatableCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - RatableCollectionViewCell class

final class RatableCollectionViewCell: DefaultCollectionViewCell {
    
    private final class TextLayer: CATextLayer {
        override func draw(in ctx: CGContext) {
            ctx.saveGState()
            ctx.translateBy(x: .zero, y: .zero)
            super.draw(in: ctx)
            ctx.restoreGState()
        }
    }
    
    private let layerView = UIView()
    private var textLayer = TextLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.addSubview(layerView)
        self.layerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.layerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.layerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.layerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.layerView.heightAnchor.constraint(equalToConstant: bounds.height / 2)
        ])
    }
    
    deinit {
        textLayer.removeFromSuperlayer()
        layerView.removeFromSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLayer.string = nil
    }
    
    override func configure(with viewModel: CollectionViewCellItemViewModel) {
        super.configure(with: viewModel)
        
        guard let indexPath = viewModel.indexPath as IndexPath? else { return }
        
        textLayer.frame = CGRect(x: -8.0,
                                 y: -8.0,
                                 width: bounds.width,
                                 height: 144.0)
        if indexPath.row == 0 {
            textLayer.frame = CGRect(x: 0.0,
                                     y: -8.0,
                                     width: bounds.width,
                                     height: 144.0)
        }
        
        let index = String(describing: indexPath.row + 1)
        let attributedString = NSAttributedString(
            string: index,
            attributes: [.font: UIFont.systemFont(ofSize: 96.0, weight: .bold),
                         .strokeColor: UIColor.white,
                         .strokeWidth: -2.5,
                         .foregroundColor: UIColor.black.cgColor])
        
        layerView.layer.insertSublayer(textLayer, at: 1)
        textLayer.string = attributedString
    }
}
