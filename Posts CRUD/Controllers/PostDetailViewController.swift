//
//  PostDetailViewController.swift
//  Posts CRUD
//
//  Created by OITD on 14/10/23.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var post: Post?
    var updatedPost : Post?
    
    @IBOutlet var postIdLabel: UILabel!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if(post != nil){
            postIdLabel.text = String(format: "Post #%d", Int(post!.id))
            titleTextView.text = post?.title
            bodyTextView.text = post?.body
        }
        
    }
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self .dismiss(animated: true)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let postsController = segue.destination as! PostsTableViewController
                
        postsController.newTitle = titleTextView.text
        postsController.newBody = bodyTextView.text
    }


}
