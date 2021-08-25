//
//  String + Extension.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 25.08.2021.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
      }
}
