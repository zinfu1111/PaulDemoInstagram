//
//  InstagramPostDetailCollectionViewController.swift
//  PaulDemoInstagram
//
//  Created by 連振甫 on 2021/8/27.
//

import UIKit

class InstagramPostDetailCollectionViewController: UICollectionViewController {
    @IBOutlet weak var postCollectionView: UICollectionView!
    var instagramPostInfo: InstagramResponse.Graphql.User.Edge_owner_to_timeline_media
    var instagramProfileUserName: String
    var instagramProfilePicURL: URL
    var indexPath: Int
    var isShow = false
    
    init?(coder: NSCoder, instagramData: InstagramResponse, indexPath: Int) {
        self.instagramPostInfo = instagramData.graphql.user.edge_owner_to_timeline_media
        self.instagramProfileUserName = instagramData.graphql.user.username
        self.instagramProfilePicURL = instagramData.graphql.user.profile_pic_url_hd
        self.indexPath = indexPath
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        //Navigation Multi Line Title
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.textColor = .black
        let userNameUpper = self.instagramProfileUserName.uppercased()
        label.text = "\(userNameUpper)\n Posts"
        self.navigationItem.titleView = label
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShow == false {
            postCollectionView.scrollToItem(at: IndexPath(item: self.indexPath, section: 0), at: .top, animated: false)
            isShow = true
        }
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension InstagramPostDetailCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return instagramPostInfo.edges.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(InstagramPostDetailCollectionViewCell.self)", for: indexPath) as? InstagramPostDetailCollectionViewCell else { return UICollectionViewCell()}
        
        //Config Profile Data
        cell.userNameLabel.text = "\(instagramProfileUserName)"
        PhotoManager.shared.downloadImage(url: instagramProfilePicURL) {[weak self] image in
            DispatchQueue.main.async {
                guard let _ = self else { return }
                cell.showProfilePicImageView.layer.cornerRadius = cell.showProfilePicImageView.frame.height / 2
                cell.showProfilePicImageView.image = image
            }
        }
        
        //Config PostData
        cell.set(for: instagramPostInfo.edges[indexPath.item])
        
        return cell
        
    }
    
}
