//
//  Model.swift
//  Insta
//
//  Created by 18529728 on 26.04.2021.
//

struct ServerModelFollowing: Codable {
    let users: [User]
    let next_max_id: String?
}

struct ServerModelFollowers: Codable {
    let users: [User]
    let next_max_id: String?
}

struct User: Codable, Hashable {
    let username: String
//        let fullName: String?
    let profile_pic_url: String?
}
