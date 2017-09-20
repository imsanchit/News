//
//  SourcesTableViewController.swift
//  News
//
//  Created by Sanchit Mittal on 15/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class SourcesTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    fileprivate var sources: [Sources] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var country: String!{
        didSet{
            extractSources(category: "", country: country!)
        }
    }
    var category: String!{
        didSet{
            extractSources(category: category!, country: "")
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 154.0
        let nib = UINib(nibName: "SourcesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SourceCell")
        if category == nil &&  country == nil {
            extractSources(category: "", country: "")
        }
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FilterPopOverTableViewControllerIdentifier") as! FilterPopOverTableViewController
         vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        vc.owner = self
        let popOver = vc.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender as UIBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    private func extractSources(category: String , country: String) {
        let path = "https://newsapi.org/v1/sources?language=en&category="+category+"&country="+country
        let url = URL(string: path)
        refreshControl?.beginRefreshing()
        let task = URLSession.shared.dataTask(with: url!) { [weak self] data, response, error  in
            guard let data = data, error == nil else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    if let source = json["sources"]! as? [[String: Any]] {
                        var sources: [Sources] = []
                        for data in source {
                            do {
                                try sources.append(Sources(json: data))
                            }
                        }
                        
                        DispatchQueue.main.async {
                            guard let strongSelf = self else { return }
                            strongSelf.sources = sources
                            strongSelf.refreshControl?.endRefreshing()
                            if sources.count == 0 {
                                strongSelf.showAlertDialog()
                            }
                        }
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func showAlertDialog(){
        let alert = UIAlertController(title: "Sorry", message: "No sources found. Change your filter", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SourcesTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath) as! SourcesTableViewCell
        cell.configureCell(source: sources[indexPath.row], parent: self)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
}
