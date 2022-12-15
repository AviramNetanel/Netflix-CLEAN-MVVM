//
//  RatedCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

final class RatedCollectionViewCell: CollectionViewCell {
    fileprivate final class TextLayer: CATextLayer {
        override func draw(in ctx: CGContext) {
            ctx.saveGState()
            ctx.translateBy(x: .zero, y: .zero)
            super.draw(in: ctx)
            ctx.restoreGState()
        }
    }
    
    fileprivate let layerView = UIView()
    fileprivate var textLayer = TextLayer()
    
    deinit {
        textLayer.removeFromSuperlayer()
        layerView.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewDidLoad()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLayer.string = nil
    }
    
    override func viewDidConfigure(with viewModel: CollectionViewCellViewModel) {
        super.viewDidConfigure(with: viewModel)
        
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
    
    fileprivate func viewDidLoad() {
        contentView.addSubview(layerView)
        
        layerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            layerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            layerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            layerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            layerView.heightAnchor.constraint(equalToConstant: bounds.height / 2)
        ])
    }
}
