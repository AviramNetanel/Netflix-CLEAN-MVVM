//
//  DebugPrint.swift
//  netflix
//
//  Created by Zach Bazov on 12/10/2022.
//

import Foundation

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
