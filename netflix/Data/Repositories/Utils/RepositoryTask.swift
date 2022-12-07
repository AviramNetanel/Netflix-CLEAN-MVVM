//
//  RepositoryTask.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

final class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
