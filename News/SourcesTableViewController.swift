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
        let category = categoryFilter == .all ? "" : categoryFilter.description()
        let country = countryFilter == .all ? "" : countryFilter.description()
        let path = "https://newsapi.org/v1/sources?language=en&category="+category+"&country="+country
        let url = URL(string: path)
        refreshControl?.beginRefreshing()
        
        NewsApiManager.sharedInstance.getResponse(url: url!,completion: { (_ responseType: SourcesResponse?, _ error: Error?) -> Void in
            if error != nil {
                self.showAlertDialog(message: "Some error occurred . Try again")
                return
            }
            self.refreshControl?.endRefreshing()
            self.sourcesResponse = responseType
            if responseType?.sources?.count == 0 {
            self.showAlertDialog(message: "No sources found. Change your filter")
            }
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

//        Alamofire.request("https://newsapi.org/v1/sources").responseJSON { response in
//            print("Request: \(String(describing: response.request))")
//            print("Response: \(String(describing: response.response?.statusCode))")
//            print("Result: \(response.result)")
//
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
//        }


//_______________________________________________________________________________________________________________________________________________________________


//        Alamofire.request(
//        URL(string: path)!,
//        method: .get,
//        parameters: ["language" : "en", "category" : category, "country" : country]).validate()
//
//            .responseJSON(completionHandler: { [weak self] (response) -> Void in
//                guard let strongSelf = self else { return }
//                guard response.result.isSuccess else {
//                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
//                    strongSelf.completion(nil)
//                return
//            }
//            guard let json = response.result.value as? [String: Any] ,
//                let source = json["sources"] as? [[String: Any]] else {
//                    print("Malformed data received from api")
//                  strongSelf.completion(nil)
//                    return
//            }
//          strongSelf.completion(source)
//        })


//    func completion(_ source : [[String: Any]]?) {
//        var sources: [Sources] = []
//        guard source != nil else {
//            return
//        }
//        for data in source! {
//            do {
//                try sources.append(Sources(json: data))
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//        }
//        self.sources = sources
//        self.refreshControl?.endRefreshing()
//        if sources.count == 0 {
//            self.showAlertDialog()
//        }
//    }


//    fileprivate func fetchSourcesFor(categoryFilter: CategoryFilters , countryFilter: CountryFilters) {
//        let category = categoryFilter == .all ? "" : categoryFilter.description()
//        let country = countryFilter == .all ? "" : countryFilter.description()
//        let path = "https://newsapi.org/v1/sources?language=en&category="+category+"&country="+country
//        let url = URL(string: path)
//        refreshControl?.beginRefreshing()
//        let task = URLSession.shared.dataTask(with: url!) { [weak self] data, response, error  in
//            guard let data = data, error == nil else { return }
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
//                    if let source = json["sources"]! as? [[String: Any]] {
//                        var sources: [Sources] = []
//                        for data in source {
//                            do {
//                                try sources.append(Sources(json: data))
//                            }
//                        }
//
//                        DispatchQueue.main.async {
//                            guard let strongSelf = self else { return }
//                            strongSelf.sources = sources
//                            strongSelf.refreshControl?.endRefreshing()
//                            if sources.count == 0 {
//                                strongSelf.showAlertDialog()
//                            }
//                        }
//                    }
//                }
//            }catch {
//                print(error.localizedDescription)
//            }
//        }
//        task.resume()
//    }
//
