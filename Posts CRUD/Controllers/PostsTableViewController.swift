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
    
    var newTitle : String?
    var newBody : String?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController =  segue.destination as! UINavigationController
        let detailController = navController.viewControllers.first as! PostDetailViewController
        
        detailController.post = sender as? Post                
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.POST_CELL_REUSE_ID, for: indexPath)
        
        let post = myPosts[indexPath.row]

        cell.textLabel?.text = String(format: "Post #%d", post.id)
        cell.detailTextLabel?.text = post.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            postService.deletePost(post: self.myPosts[indexPath.row]) {
                self.myPosts = self.postManager.getAllPosts()
                
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = myPosts[indexPath.row]
        
        self.performSegue(withIdentifier: AppConstants.SHOW_DETAIL_SEGUE_ID, sender: selectedPost)
    }
    
    @IBAction func unwindToPostsTable(segue: UIStoryboardSegue){
        // Update Cell
        postService.updatePost(post: myPosts[tableView.indexPathForSelectedRow!.row], newTitle: newTitle!, newBody: newBody!) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
