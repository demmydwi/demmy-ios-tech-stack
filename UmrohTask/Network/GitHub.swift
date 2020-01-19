//
//  Github.swift
//  UmrohTask
//
//  Created by Demmy Dwi Rhamadan on 15/01/20.
//  Copyright © 2020 Demmy Dwi Rhamadan. All rights reserved.
//

import Foundation
import Moya

public enum GitHub {
    case repository(query: String, page: Int)
}

extension GitHub: TargetType {
  public var baseURL: URL {
    return URL(string: "https://api.github.com/search")!
  }

  public var path: String {
    switch self {
    case .repository(_, _): return "/repositories"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .repository(_, _): return .get
    }
  }

  public var sampleData: Data {
    return Data()
  }

  public var task: Task {
    switch self {
    case .repository(let query, let page):
      return .requestParameters(parameters: [
        "q": query,
        "page": page,
        "per_page": 10
      ], encoding: URLEncoding.queryString)
    }   
  }

  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}
