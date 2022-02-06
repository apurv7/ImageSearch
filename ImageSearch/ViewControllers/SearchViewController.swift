//
//  SearchViewController.swift
//  ImageSearch
//
//  Created by apurv on 06/02/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tvMain: UITableView!
    
    var manager = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchRecentImages()
    }
}

extension SearchViewController {
    
    ///func to setup initial UI
    private func setupUI() {
        self.tvMain.register(UINib.init(nibName: ImageDetailsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ImageDetailsTableViewCell.identifier)
        self.tvMain.register(UINib.init(nibName: NoDataTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NoDataTableViewCell.identifier)
    }
    
    ///func to fetch recent images from view model
    private func fetchRecentImages() {
        
        self.manager.cells.removeAll()
        
        if let _ = self.manager.imageModel {
            self.manager.cells.append(.searched)
        }
        if self.manager.getRecentlySavedImages().count > 0 {
            self.manager.cells.append(.recent)
        }
        self.reloadTableView()
        self.view.removeLoader()
    }
    
    ///search image handler
    private func searchImage(date: String) {
        self.view.showLoader()
        self.manager.getImageData(date: date) { [weak self] in
            
            guard let this = self else {
                return
            }
            
            DispatchQueue.main.async {
                this.fetchRecentImages()
            }
        }
    }
    
    ///method to reload tableview
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tvMain.reloadData()
        }
    }
}

extension SearchViewController {
    
    ///method called when user pressed search button
    @IBAction func btnSearchPressed() {
        guard let dateStr = self.tfDate.text, !(dateStr.isEmpty) else {
            showToast(Constants.dateError)
            return
        }
        
        if Helper.validateDate(date: dateStr) {
            self.searchImage(date:dateStr)
        } else {
            showToast(Constants.dateError)
        }
    }
}

//MARK:- tableview datasource/delegates
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        //if no data is present, return 0 sections
        if self.manager.isNoDataPresent {
            return 0
        }
        
        return self.manager.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.manager.isNoDataPresent {
            return 0
        }
        
        switch self.manager.cells[section] {
        case .searched:
            return  1
        case .recent:
            return self.manager.getRecentlySavedImages().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.manager.isNoDataPresent {
            return UITableViewCell.init()
        } else {
            switch self.manager.cells[indexPath.section] {
            case .searched: //data of user search
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageDetailsTableViewCell.identifier) as! ImageDetailsTableViewCell
                cell.imageModel = self.manager.imageModel
                cell.btnFavouriteTapped = { [weak self] in
                    guard let this = self else { return }
                    
                    this.manager.setFavourite(date: this.manager.imageModel?.getDate() ?? "")
                    this.reloadTableView()
                }
                cell.selectionStyle = .none
                return cell
            case .recent:   //previously searched results
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageDetailsTableViewCell.identifier) as! ImageDetailsTableViewCell
                cell.imageModel = self.manager.getRecentlySavedImages()[indexPath.row]
                cell.btnFavouriteTapped = { [weak self] in
                    guard let this = self else { return }
                    
                    this.manager.setFavourite(date: this.manager.getRecentlySavedImages()[indexPath.row].getDate())
                    this.reloadTableView()
                }
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.manager.isNoDataPresent {
            return UIView()
        }
        
        switch self.manager.cells[section] {
        case .searched:
            return UIView()
        case .recent:
            let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.tvMain.frame.width, height: 20))
            label.text = "Recent Searches"
            return label
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.manager.isNoDataPresent {
            return CGFloat.leastNormalMagnitude
        }
        
        switch self.manager.cells[section] {
        case .searched:
            return CGFloat.leastNormalMagnitude
        case .recent:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        switch self.manager.cells[indexPath.section] {
        case .searched:
            viewController.imageModel = self.manager.imageModel
        case .recent:
            viewController.imageModel = self.manager.getRecentlySavedImages()[indexPath.row]
        }
        
        DispatchQueue.main.async {
            self.present(viewController, animated: true)
        }
    }
}
