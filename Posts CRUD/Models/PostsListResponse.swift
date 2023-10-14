//
//  ListPostsResponse.swift
//  Posts CRUD
//
//  Created by OITD on 14/10/23.
//

import Foundation

struct PostsListResponse<T: Codable> : Codable {
    let posts : [PostEntity]
}
