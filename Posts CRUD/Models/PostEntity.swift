//
//  PostEntity.swift
//  Posts CRUD
//
//  Created by OITD on 14/10/23.
//

import Foundation

struct PostEntity : Codable{
    let userId : Int32
    let id : Int32
    let title : String
    let body : String
}
