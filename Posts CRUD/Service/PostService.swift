//
//  PostService.swift
//  Posts CRUD
//
//  Created by OITD on 14/10/23.
//

import UIKit

class PostService {
    private var posts : [PostEntity] = []
    
    func getPost(atIndex index: Int) -> PostEntity{
        return posts[index]
    }
    
    func countPosts() -> Int {
        return posts.count
    }
    
    func loadPost(completion: @escaping() -> Void){
        let getPostUrl = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        let session = URLSession.shared
        var httpResponse = HTTPURLResponse()        
        
        let loadPostTask = session.dataTask(with:getPostUrl){ (data, response, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response")
                httpResponse = (response as? HTTPURLResponse)!
                print("statusCode: ", httpResponse.statusCode)
                return
            }
            
            // Check if there is any data
            guard let data = data else {
                print("No data received")
                return
            }
            
            do{
                let decodedResponse = try JSONDecoder().decode([PostEntity].self, from: data)
                
                for post in decodedResponse{
                    self.posts.append(post)
                    print("Post ID: ", post.id)
                }
                
            }catch let error{
                print(error)
            }
            
            completion()
        }
        
        loadPostTask.resume()
        
    }
    

}
