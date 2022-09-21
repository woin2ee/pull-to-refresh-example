//
//  Post.swift
//  PullToRefreshExample
//
//  Created by Jaewon on 2022/09/21.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
