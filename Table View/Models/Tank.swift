//
//  Tank.swift
//  Table View
//
//  Created by Андрей on 06.07.2022.
//

import UIKit

struct Tank: Codable {
    var tankImage: Data
    var name: String
    var description: String
    var type: TypeOfTank?
    
    init(tankImage: UIImage = UIImage(), name: String = "", description: String = "", type: TypeOfTank = .non) {
        self.tankImage = tankImage.pngData() ?? Data()
        self.name = name
        self.description = description
        self.type = type
    }
}

extension Tank {
    static var all: [Tank] {
        return [
            Tank(tankImage: UIImage(named: "T34")!, name: "T-34", description: "Советский танк", type: .medium),
            Tank(tankImage: UIImage(named: "KV2")!, name: "КВ-2", description: "Советский танк", type: .heavy),
        ]
    }
    
    static func loadDefaults() -> [Tank] {
        return all
    }
}
