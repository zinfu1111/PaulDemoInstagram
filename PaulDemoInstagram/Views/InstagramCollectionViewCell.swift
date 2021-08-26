//
//  InstagramCollectionViewCell.swift
//  PaulDemoInstagram
//
//  Created by 連振甫 on 2021/8/26.
//

import UIKit

class InstagramCollectionViewCell: UICollectionViewCell {
    
    var edges:InstagramResponse.Graphql.User.Edge_owner_to_timeline_media.Edges!
    
    
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var cellWidthConstraints: NSLayoutConstraint!
    static let width = floor((UIScreen.main.bounds.width - 3 * 2) / 3)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellWidthConstraints?.constant = Self.width
    }
    
    func set(for edges:InstagramResponse.Graphql.User.Edge_owner_to_timeline_media.Edges) {
        self.edges = edges
        downloadPhoto()
    }
    
    private func downloadPhoto(){
        let url = edges.node.display_url
        
        PhotoManager.shared.downloadImage(url: edges.node.display_url) {[weak self] image in
            guard let self = self,url == self.edges.node.display_url else { return }
            DispatchQueue.main.async {
                self.showImageView.image = image
            }
        }
    }
}
