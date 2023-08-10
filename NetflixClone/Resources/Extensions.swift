//
//  Extensions.swift
//  NetflixClone
//
//  Created by Ahmet Özkan on 10.08.2023.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
