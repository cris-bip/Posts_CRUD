//
//  PostDataManager.swift
//  Posts CRUD
//
//  Created by OITD on 14/10/23.
//

import Foundation
import CoreData

class PostDataManager{
    private var posts : [Post] = []
    
    private let context : NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        posts = getAllPosts()
    }
    
    func hasPosts() -> Bool{
        return posts.count > 0
    }
    
    func getPosts() -> [Post]{
        return posts
    }
    
    func savePost(userId: Int16, id: Int16, title: String, body: String) -> Post?{
        
        let newPost = Post(context: context)
        newPost.userId = userId
        newPost.id = id
        newPost.title = title
        newPost.body = body
        
        do{
            try context.save()
            return newPost
        }catch let error{
            print(error)
            return nil
        }
    }
    
    func getAllPosts() -> [Post] {
        if let posts = try? self.context.fetch(Post.fetchRequest()){
            return posts
        }else{
            return[]
        }
    }
    
    func getPostById(id: Int16) -> Post?{
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        var predicate: NSPredicate?
        
        predicate = NSPredicate(format: "id = %@", id as CVarArg)

        fetchRequest.predicate = predicate
        
        do{
            let post = try context.fetch(fetchRequest)
            return post.first
        }catch let error{
            print(error)
            return nil
        }
    }
}
