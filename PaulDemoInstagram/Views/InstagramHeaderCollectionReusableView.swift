//
//  InstagramHeaderCollectionReusableView.swift
//  PaulDemoInstagram
//
//  Created by 連振甫 on 2021/8/26.
//

import UIKit

class InstagramHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var biographyTextView: UITextView!
    
    private var instagramData: InstagramResponse!
    
    func set(for instagramData:InstagramResponse) {
        self.instagramData = instagramData
        self.postsLabel.text = instagramData.graphql.user.edge_owner_to_timeline_media.count.numCoverter
        self.followersLabel.text = instagramData.graphql.user.edge_followed_by.count.numCoverter
        self.followingLabel.text = instagramData.graphql.user.edge_follow.count.numCoverter
        self.fullNameLabel.text = "\(instagramData.graphql.user.full_name)"
        self.biographyTextView.isEditable = false
        self.biographyTextView.text = "\(instagramData.graphql.user.biography)"
        downloadPhoto()
    }
    
    private func downloadPhoto(){
        PhotoManager.shared.downloadImage(url: instagramData.graphql.user.profile_pic_url_hd) { image in
            DispatchQueue.main.async {
                self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.width / 2
                self.profilePicImageView.image = image
            }
        }
    }
}
