//
//  PostService.swift
//  Posts CRUD
//
//  Created by OITD on 14/10/23.
//

import UIKit

class PostService {
    private var posts : [PostModel] = []
    
    let postManager = PostDataManager(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    func getAllPosts() -> [PostModel] {
        return posts
    }
    
    func getPost(atIndex index: Int) -> PostModel{
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
                let decodedResponse = try JSONDecoder().decode([PostModel].self, from: data)
                
                for post in decodedResponse{
                    self.posts.append(post)
                    
                    let post = self.postManager.savePost(userId: Int16(post.userId), id: Int16(post.id), title: post.title, body: post.title)
                    
                    print("Post guardado: ", post!.id)
                }
                
            }catch let error{
                print(error)
            }
            
            completion()
        }
        
        loadPostTask.resume()
        
    }
    

    
    func deletePost(post: Post, completion: @escaping () -> Void){
        let url = String(format: "https://jsonplaceholder.typicode.com/posts/%d", post.id)
        let deletePostUrl = URL(string:url)!
        
        let request = NSMutableURLRequest(url: deletePostUrl)
        request.httpMethod = "DELETE"
        
        let session = URLSession.shared
        var httpResponse = HTTPURLResponse()
        
        let deleteTask = session.dataTask(with: request as URLRequest){data, response, error in
            
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
            
            // Delete from DB
            let deletedPost = self.postManager.deletePost(post: post)
            print("Post eliminado correctamente?: ", deletedPost ? "SI" : "NO")
            
            if(deletedPost){
                completion()
            }            
        }
        
        deleteTask.resume()
    }
    
    func updatePost(post : Post, newTitle: String, newBody: String, completion:@escaping () -> Void){
        let url = String(format: "https://jsonplaceholder.typicode.com/posts/%d", post.id)
        let deletePostUrl = URL(string:url)!
        
        post.title = newTitle
        post.body = newBody
        
        guard let jsonData = try? JSONEncoder().encode(post) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        let request = NSMutableURLRequest(url: deletePostUrl)
        request.httpMethod = "PUT"
        
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.httpBody = jsonData
        
        let session = URLSession.shared
        var httpResponse = HTTPURLResponse()
        
        let updateTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
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
                        
            print("Data from response: ", String(data: data, encoding: String.Encoding.utf8)!)
            
            // Update DB
            let updatedPost = self.postManager.updatePost(post: post, title: newTitle, body: newBody)
            
            print("Post actualizado: %@", updatedPost!)
            
            completion()
            
        }
        
        updateTask.resume()
    }
}
