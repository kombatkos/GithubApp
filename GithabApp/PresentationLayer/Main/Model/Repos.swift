//
//  Repos.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 13.08.2021.
//

import Foundation

struct Repos: Codable {
    var id: Int?
    var nodeId: String?
    var name: String?
    var htmlUrl: String?
    var description: String?
    var url: String?
    var archiveUrl: String?
    var stargazersCount: Int?
    var owner: User?
}
