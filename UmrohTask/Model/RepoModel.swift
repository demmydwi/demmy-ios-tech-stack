// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let repoResponse = try? newJSONDecoder().decode(RepoResponse.self, from: jsonData)
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let repoResponse = try? newJSONDecoder().decode(RepoResponse.self, from: jsonData)

import Foundation
import RxDataSources

// MARK: - RepoResponse
struct RepoResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [RepoModel]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - RepoError
struct RepoError: Codable {
    let message: String
}

struct RepoModelSectioned: Codable, Equatable {
    let header: String
    var data: [RepoModel]
    
    static func copyWith(_ page: String, _ repoModels: [RepoModel]) -> RepoModelSectioned {
        return RepoModelSectioned(header: page, data: repoModels)
    }
}

extension RepoModelSectioned :AnimatableSectionModelType {
    
    init(original: RepoModelSectioned, items: [RepoModel]) {
        self = original
        self.data = items
    }
    
    var count: Int {
        return data.count ?? 0
    }
    
    typealias Item = RepoModel
    typealias Identity = String

    var identity: String {
        return header
    }

    var items: [RepoModel] {
        return data
    }
}

func == (lhs: RepoModel, rhs: RepoModel) -> Bool {
    return lhs.id == rhs.id && lhs.fullName == rhs.fullName
}

func == (lhs: RepoModelSectioned, rhs: RepoModelSectioned) -> Bool {
    return lhs.header == rhs.header && lhs.items == rhs.items
}

// MARK: - RepoModel
struct RepoModel: Codable, Equatable, IdentifiableType {
    
    typealias Identity = Int
    
    var identity: Int {
        return id ?? 0
    }
    
    let id: Int?
    var isLoadingView: Bool?
    let nodeID, name, fullName: String?
    let owner: Owner?
    let htmlURL: String?
    let itemDescription: String?
    let url: String?
    let createdAt, updatedAt, pushedAt: String?
    let gitURL, sshURL: String?
    let cloneURL: String?
    let size: Int?
    let language: String?
    let forks, openIssues, watchers: Int?
    let defaultBranch: String?
    let score: Double?
    
    static func loadingView() -> RepoModel {
        return RepoModel(id: nil, isLoadingView: true, nodeID: nil, name: nil, fullName: nil, owner: nil, htmlURL: nil, itemDescription: nil, url: nil, createdAt: nil, updatedAt: nil, pushedAt: nil, gitURL: nil, sshURL: nil, cloneURL: nil, size: nil, language: nil, forks: nil, openIssues: nil, watchers: nil, defaultBranch: nil, score: nil)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case isLoadingView = "loading_view"
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case owner
        case htmlURL = "html_url"
        case itemDescription = "description"
        case url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case gitURL = "git_url"
        case sshURL = "ssh_url"
        case cloneURL = "clone_url"
        case size, language, forks
        case openIssues = "open_issues"
        case watchers
        case defaultBranch = "default_branch"
        case score
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL, url, htmlURL: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case url
        case htmlURL = "html_url"
        case type
    }
}
