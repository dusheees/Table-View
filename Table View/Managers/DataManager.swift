//
//  DataManager.swift
//  Table View
//
//  Created by Андрей on 06.07.2022.
//

import Foundation

class DataManager {
    var archiveURL: URL? {
        guard let documetDirector = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documetDirector.appendingPathComponent("tanks").appendingPathExtension("plist")
    }
    
    func loadTanks() -> [Tank]? {
        guard let archiveURL = archiveURL else { return nil }
        guard let encodedEmojis = try? Data(contentsOf: archiveURL) else { return nil }
        
        let decoder = PropertyListDecoder()
        return try? decoder.decode([Tank].self, from: encodedEmojis)
    }
    
    func saveTanks(_ tanks: [Tank]) {
        guard let archiveURL = archiveURL else { return }

        let encoder = PropertyListEncoder()
        guard let encodedEmojis = try? encoder.encode(tanks) else { return }
        
        try? encodedEmojis.write(to: archiveURL, options: .noFileProtection)
    }
}

