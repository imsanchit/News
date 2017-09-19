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

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        extractSources()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 154.0
        let nib = UINib(nibName: "SourcesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SourceCell")
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FilterPopOverViewControllerIdentifier") as! FilterPopOverViewController
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popOver = navController.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender as UIBarButtonItem
        present(navController, animated: true, completion: nil)
        
    }
    private func extractSources() {
        let url = URL(string: "https://newsapi.org/v1/sources?language=en")
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
/*                            for s in sources {
                                print(s.id!)
                                print(s.name!)
                                print(s.description!)
                                print(s.category!)
                                print(s.country!)
                                print(s.language!)
                                print(s.url!)
                            }
*/
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
