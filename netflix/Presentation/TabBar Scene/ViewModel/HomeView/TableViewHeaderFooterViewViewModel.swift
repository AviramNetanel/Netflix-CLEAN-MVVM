//
//  TableViewHeaderFooterViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 15/11/2022.
//

import Foundation

// MARK: - ViewModelInput protocol

private protocol ViewModelInput {
    func title(_ sections: [Section], forHeaderAt index: Int) -> String
}

// MARK: - ViewModelOutput protocol

private protocol ViewModelOutput {}

// MARK: - ViewModel typealias

private typealias ViewModel = ViewModelInput & ViewModelOutput

// MARK: - TableViewHeaderFooterViewViewModel struct

struct TableViewHeaderFooterViewViewModel: ViewModel {
    
    func title(_ sections: [Section],
               forHeaderAt index: Int) -> String {
        .init(describing: sections[index].title)
    }
}
