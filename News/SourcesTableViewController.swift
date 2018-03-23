//
//  SourcesTableViewController.swift
//  News
//
//  Created by Sanchit Mittal on 15/09/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class SourcesTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    var selectedCategoryFilter: CategoryFilters = .all
    var selectedCountryFilter: CountryFilters = .all

    
    fileprivate var sourcesResponse: SourcesResponse? {
        didSet {
            tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 154.0
        let nib = UINib(nibName: "SourcesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SourceCell")
        fetchSourcesFor(categoryFilter: .all, countryFilter: .all)
    }
    
    @IBAction func filter(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FilterPopOverTableViewControllerIdentifier") as! FilterPopOverTableViewController
         vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height)
        vc.modalPresentationStyle = .popover
        vc.delegate = self
        vc.selectedCategoryFilter = selectedCategoryFilter
        vc.selectedCountryFilter = selectedCountryFilter
        let popOver = vc.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender as UIBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
    fileprivate func fetchSourcesFor(categoryFilter: CategoryFilters , countryFilter: CountryFilters) {
        refreshControl?.beginRefreshing()
        NewsApiManager.sharedInstance.getSources(categoryFilter: categoryFilter, countryFilter: countryFilter, showResponse: { [weak self] (_ sourceResponse: SourcesResponse?) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.refreshControl?.endRefreshing()
            strongSelf.sourcesResponse = sourceResponse
            if sourceResponse?.sources?.count == 0 {
                strongSelf.showAlertDialog(message: "No sources found. Change your filter")
            }
        }, showError: { [weak self] () -> Void in
            guard let strongSelf = self else { return }
            strongSelf.showAlertDialog(message: "Some error occurred . Try again")
        })
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func showAlertDialog(message: String){
        let alert = UIAlertController(title: "Sorry", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SourcesTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath) as! SourcesTableViewCell
        cell.configureCell(source: (sourcesResponse?.sources?[indexPath.row])!, parent: self)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesResponse?.sources?.count ?? 0
    }
}

extension SourcesTableViewController : FilterPopOverTableViewControllerProtocol {
    func applyfilters(category: CategoryFilters, country: CountryFilters) {
        selectedCategoryFilter = category
        selectedCountryFilter = country
        fetchSourcesFor(categoryFilter: category, countryFilter: country)
    }
}
