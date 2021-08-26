//
//  viewModel.swift
//  Insta
//
//  Created by 18529728 on 27.04.2021.
//

import Foundation

final class ViewModel {

    var dataBase: [User] = []

    init(dsUserId: String, sessionId: String) {
        self.dsUserId = dsUserId
        self.sessionId = sessionId
    }

    func updateDataBase(complition: @escaping (() -> Void)) {
        followers = []
        following = []

        group.enter()
        reqest(type: .followers) {
            self.group.leave()
        }

        group.enter()
        reqest(type: .following) {
            self.group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let namesFollowing = Set(self.following.map({ $0.username }))
            let namesFollowers = Set(self.followers.map({ $0.username }))
            let diffNames = namesFollowing.symmetricDifference(namesFollowers).sorted(by: <)
            var diffNamesSet = Set(diffNames)
            namesFollowers.forEach({ diffNamesSet.remove($0) })
            let newDiffsNames = Array(diffNamesSet).sorted(by: <)
            self.dataBase = newDiffsNames.compactMap { [weak self] name -> User? in
                guard let self = self else { return nil }
                return self.following.first(where: { $0.username == name })
            }
            complition()
        }
    }

    private let group = DispatchGroup()
    private enum ReqestType: String {
        case followers
        case following
    }

    private var dsUserId: String
    private var sessionId: String
    private var followers: Set<User> = []
    private var following: Set<User> = []

    private func configRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)

        request.addValue("i.instagram.com", forHTTPHeaderField: "Host")
        request.addValue("ds_user_id=\(dsUserId); sessionid=\(sessionId);", forHTTPHeaderField: "Cookie")
        request.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "accept")
        request.addValue("3w==", forHTTPHeaderField: "x-ig-capabilities")
        request.addValue("i.instagram.com/", forHTTPHeaderField: "authorization")
        request.addValue("Instagram 46.0.0 (iPhone7,2; iPhone OS 9_3_3; en_US; en-US; scale=2.00; 750x1334) AppleWebKit/420+", forHTTPHeaderField: "user-agent")
        request.addValue("https://www.instagram.com/", forHTTPHeaderField: "referer")
        request.addValue("en-GB,en-US;q=0.8,en;q=0.6", forHTTPHeaderField: "accept-language")
        return request
    }

    private func reqest(type: ReqestType, param: String = "", complition: @escaping (() -> Void)) {
        let urlString = "https://i.instagram.com/api/v1/friendships/\(dsUserId)/\(type.rawValue)/?max_id=\(param)"


        guard let url = URL(string: urlString) else {
            print(NSError(domain: "Insta", code: 0, userInfo: [NSLocalizedDescriptionKey: "addingPercentEncoding returns nil"]))
            return
        }

        let request = configRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, responce, error in
            guard let self = self else { return }
            defer {
                self.group.leave()
            }
            if let data = data {
                do {

                    switch type {
                    case .followers:
                        let serverModel = try JSONDecoder().decode(ServerModelFollowers.self, from: data)
                        serverModel.users.forEach({ self.followers.insert($0) })
                        if let nextMaxID = serverModel.next_max_id {
                            self.group.enter()
                            self.reqest(type:  type, param: nextMaxID) {
                                self.group.leave()
                            }
                        }
                    case .following:
                        let serverModel = try JSONDecoder().decode(ServerModelFollowing.self, from: data)
                        serverModel.users.forEach({ self.following.insert($0) })
                        if let nextMaxID = serverModel.next_max_id {
                            self.group.enter()
                            self.reqest(type:  type, param: "\(nextMaxID)") {
                                self.group.leave()
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
