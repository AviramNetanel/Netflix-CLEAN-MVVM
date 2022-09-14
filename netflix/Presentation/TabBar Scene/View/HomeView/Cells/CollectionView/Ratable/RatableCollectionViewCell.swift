//
//  RatableCollectionViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - TextLayerView

final class TextLayerView: CATextLayer {
    
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: 0.0)
        
        super.draw(in: ctx)
        
        ctx.restoreGState()
    }
}


// MARK: - RatableCollectionViewCell

final class RatableCollectionViewCell: DefaultCollectionViewCell {
    
    // MARK: Properties
    
    let layerContainer = UIView()
    
    private(set) var textLayerView = TextLayerView()
    
    
    // MARK: Initialization & Deintialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.addSubview(layerContainer)
        self.layerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.layerContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.layerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.layerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.layerContainer.heightAnchor.constraint(equalToConstant: bounds.height / 2)
        ])
    }
    
    deinit {
        textLayerView.removeFromSuperlayer()
        layerContainer.removeFromSuperview()
    }
    
    
    // MARK: Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLayerView.string = nil
    }
}
