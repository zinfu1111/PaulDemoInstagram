//
//  InstagramCollectionViewController.swift
//  PaulDemoInstagram
//
//  Created by 連振甫 on 2021/8/26.
//

import UIKit

class InstagramCollectionViewController: UICollectionViewController {

    var instagramData: InstagramResponse?
    var instagramPostPicture =  [InstagramResponse.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData()
        
    }
    
    func fetchData() {
        InstagramResponse.sendRequest(method: .get, reponse: InstagramResponse.self) { result in
            switch result {
            case .success(let data):
                self.instagramData = data
                DispatchQueue.main.async {
                    self.instagramPostPicture = data.graphql.user.edge_owner_to_timeline_media.edges
                    self.navigationItem.title = data.graphql.user.username
                    self.navigationItem.backButtonTitle = "Profile"
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBSegueAction func showPostDetail(_ coder: NSCoder) -> InstagramPostDetailCollectionViewController? {
        guard let row = collectionView.indexPathsForSelectedItems?.first?.row else {return nil}
        //print("row:\(row)")
        return InstagramPostDetailCollectionViewController(coder: coder, instagramData: instagramData!, indexPath: row)
    }


}

extension InstagramCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return instagramPostPicture.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(InstagramCollectionViewCell.self)", for: indexPath) as? InstagramCollectionViewCell else { return UICollectionViewCell()}
        
        cell.set(for: instagramPostPicture[indexPath.row])
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let resuableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(InstagramHeaderCollectionReusableView.self)", for: indexPath) as? InstagramHeaderCollectionReusableView else {return UICollectionReusableView()}
        
        guard let instagramData = self.instagramData else { return resuableView }
        resuableView.set(for: instagramData)
        
        return resuableView
    }
    
}
