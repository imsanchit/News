//
//  ArticlesTableViewCell.swift
//  News
//
//  Created by Sanchit Mittal on 19/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class ArticlesTableViewCell: UITableViewCell {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var url = ""
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var articleImage: UIImageView!{
        didSet {
            articleImage.layer.borderWidth = (5 / UIScreen.main.scale)
            articleImage.layer.borderColor = UIColor.black.cgColor
            articleImage.layer.masksToBounds = true
            
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = .gray
            articleImage.addSubview(activityIndicator)
        }
    }
    @IBOutlet weak var desc: UILabel!
    @IBAction func openArticle(_ sender: UIButton) {
        let url = URL(string: self.url)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    public func configureCell(article: Article , parent: ArticlesTableViewController) {
        
        title.text = article.title
        publishDate.text = article.publishedAt
        author.text = article.author
        desc.text = article.description
        url = article.url!
        let imageURL = URL(string: article.urlToImage!)
        startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }
            do {
                let imageData = try Data(contentsOf: imageURL!)
                DispatchQueue.main.async {
                    strongSelf.stopAnimating()
                    strongSelf.articleImage.image = UIImage(data: imageData)
                }
            } catch let error {
                print("\(error)")
            }
        }
    
    }
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
