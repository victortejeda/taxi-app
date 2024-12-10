//
//  Driver.swift
//  prueva
//
//  Created by Victor Tejeda on 8/12/24.
//

import Foundation

struct Driver: Identifiable {
    let id = UUID()
    var number: Int
    var phone: String
    var name: String
    var status: String
    var type: String
    var isOnline: Bool
    var photo: String? // Campo opcional para incluir fotos
}

