//
//  PostsTableViewController.swift
//  Posts CRUD
//
//  Created by OITD on 14/10/23.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    var myPosts : [Post] = []

    let postService = PostService()
    
    let postManager = PostDataManager(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(postManager.hasPosts()){
            // Consulta de la BD
            myPosts = postManager.getPosts()
        }else{
            // Lee los post del WS
            postService.loadPost{
                self.myPosts = self.postManager.getAllPosts()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.POST_CELL_REUSE_ID, for: indexPath) as UITableViewCell
        
        let post = myPosts[indexPath.row]

        cell.textLabel?.text = String(format: "Post #%d", post.id)
        cell.detailTextLabel?.text = post.title
        return cell
    }
}
