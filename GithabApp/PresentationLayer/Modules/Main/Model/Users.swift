//
//  Users.swift
//  GithabApp
//
//  Created by Konstantin Porokhov on 10.08.2021.
//

import Foundation

struct Users: Codable, Hashable {
    var totalCount: Int?
    var incompleteResults: Bool?
    var items: [User]?
}

struct User: Codable, Hashable {
    var login: String?
    var id: Int?
    var nodeId: String?
    var avatarUrl: String?
    var gravatarId: String?
    var url: String?
    var htmlUrl: String?
    var followersUrl: String?
    var followingUrl: String?
    var gistsUrl: String?
    var starredUrl: String?
    var subscriptionsUrl: String?
    var organizationsUrl: String?
    var reposUrl: String?
    var eventsUrl: String?
    var receivedEventsUrl: String?
    var type: String?
    var siteAdmin: Bool?
    var score: Double?
    var repos: [Repos]? = []
}

extension User {
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.login == rhs.login
    }
    
    func hash(into hasher: inout Hasher) {
        login.hash(into: &hasher)
    }
}

