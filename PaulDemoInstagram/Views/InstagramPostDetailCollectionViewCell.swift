//
//  InstagramPostDetailCollectionViewCell.swift
//  PaulDemoInstagram
//
//  Created by 連振甫 on 2021/8/27.
//

import UIKit

class InstagramPostDetailCollectionViewCell: UICollectionViewCell {
    
    var likeButtonStatus: Bool = false
    var edges:InstagramResponse.Graphql.User.Edge_owner_to_timeline_media.Edges!
    
    @IBOutlet weak var showPostImageView: UIImageView!
    @IBOutlet weak var showProfilePicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postCommentCountLabel: UILabel!
    @IBOutlet weak var postCaptionTextView: UITextView!
    @IBOutlet weak var postLikeLabel: UILabel!
    @IBOutlet weak var postLikeButton: UIButton!
    
    func set(for edges:InstagramResponse.Graphql.User.Edge_owner_to_timeline_media.Edges) {
        self.edges = edges
        
        
        //Init button icon
        self.postLikeButton.setImage(UIImage(named: "iconLove"), for: UIControl.State.normal)
        
        let postLikeCount = edges.node.edge_liked_by.count.numCoverter
        self.postLikeLabel.text = "Liked by Marso and  \(postLikeCount) others"

        self.postCaptionTextView.isEditable = false
        self.postCaptionTextView.isScrollEnabled = false
        self.postCaptionTextView.text = edges.node.edge_media_to_caption.edges.first?.node.text ?? ""
        
        let postCommentCount = edges.node.edge_media_to_comment.count.numCoverter
        self.postCommentCountLabel.textColor = .gray
        self.postCommentCountLabel.text = "View all \(postCommentCount) comments"
        
        //Post Time Transfor
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: edges.node.taken_at_timestamp)
        self.postDateLabel.text = "\(dateString)"
        
        downloadPhoto()
    }
    
    private func downloadPhoto(){
        let url = self.edges.node.display_url
        
        //Fetch Post Image
        PhotoManager.shared.downloadImage(url: edges.node.display_url) {[weak self] image in
            DispatchQueue.main.async {
                guard let self = self,url == self.edges.node.display_url else { return }
                let border = CALayer()
                border.backgroundColor = UIColor.systemGray3.cgColor
                border.frame = CGRect(x: 0, y: 0, width: self.showPostImageView.frame.width, height: 0.3)
                self.showPostImageView.layer.addSublayer(border)
                self.showPostImageView.image = image
            }
        }
        
        
    }
    
    @IBAction func postLikeButton(_ sender: Any) {
       likeButtonStatus = !likeButtonStatus
        if likeButtonStatus {
            postLikeButton.setImage(UIImage(named: "iconRedLove"), for: UIControl.State.normal)
        }
        else {
            postLikeButton.setImage(UIImage(named: "iconLove"), for: UIControl.State.normal)
        }
    }
}
