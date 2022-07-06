//
//  CellManager.swift
//  Table View
//
//  Created by Андрей on 06.07.2022.
//

import UIKit

class CellManager {
    func configure(_ cell: TankCell, with tank: Tank) {
        cell.tankImageView.image = UIImage(data: tank.tankImage)
        cell.nameLabel.text = tank.name
        cell.descriptionLabel.text = tank.description
    }
}
