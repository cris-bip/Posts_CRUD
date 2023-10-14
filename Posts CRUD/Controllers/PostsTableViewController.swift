//
//  PostsTableViewController.swift
//  Posts CRUD
//
//  Created by OITD on 14/10/23.
//

import UIKit

class PostsTableViewController: UITableViewController {

    let postService = PostService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postService.loadPost{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postService.countPosts()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.POST_CELL_REUSE_ID, for: indexPath) as UITableViewCell
        
        let post = postService.getPost(atIndex: indexPath.row)
        
        cell.textLabel?.text = String(format: "Post #%d", post.id)
        cell.detailTextLabel?.text = post.title
        return cell
    }
}
