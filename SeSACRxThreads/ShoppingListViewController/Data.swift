//
//  Data.swift
//  SeSACRxThreads
//
//  Created by 심소영 on 8/5/24.
//

import Foundation

struct ShoppingList: Hashable, Identifiable {
    let id = UUID()
    var like: Bool
    var check: Bool
    let textLabel: String
}
