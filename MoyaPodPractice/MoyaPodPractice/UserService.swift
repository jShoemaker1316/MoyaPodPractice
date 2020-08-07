//
//  UserService.swift
//  MoyaPodPractice
//
//  Created by Jonathan Shoemaker on 8/7/20.
//  Copyright © 2020 Jonathan Shoemaker. All rights reserved.
//

import Foundation
import Moya
//moya bundles everything into an enum which we will work off of
enum UserService {
    case createUser(name: String)
    case readUsers
    case updateUser(id: Int, name: String)
    case deleteUser(id: Int)
}
//conform to targettype let error auto fill vars for protocal
extension UserService: TargetType {
    var baseURL: URL {
        return URL(string: "jsonplaceholder.typicode.com")!
    }

    var path: String {
        switch self {
        case .readUsers, .createUser(_):
            return "/users"

        case .updateUser(let id, _), .deleteUser(let id):
            return "/users/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createUser(_):
            return .post

        case .readUsers:
            return .get

        case .updateUser(_, _):
            return .put

        case .deleteUser(_):
            return .delete
        }
    }

    var sampleData: Data {
        switch self {
        case .createUser(let name):
            return "{'name':'\(name)'}".data(using: .utf8)!
//make these returns in json format and use utf8 for the data
        case .readUsers:
            return Data()

        case .updateUser(let id, let name):
            return"{'id':'\(id)', 'name':'\(name)'}".data(using: .utf8)!

        case .deleteUser(let id):
            return "{'id':'\(id)'}".data(using: .utf8)!
        }
    }

    var task: Task {
        switch self {
        case .readUsers, .deleteUser(_):
            return .requestPlain
        case .createUser(let name), .updateUser(_, let name):
            return .requestParameters(parameters: ["name": name], encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }


}
