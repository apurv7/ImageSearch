//
//  FavouritesViewController.swift
//  ImageSearch
//
//  Created by apurv on 06/02/2022.
//

import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet weak var tvMain: UITableView!

    var manager = FavouriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupUI()
    }
}

extension FavouritesViewController {
    
    ///func to setup/reload data
    private func setupUI() {

        self.tvMain.register(UINib.init(nibName: ImageDetailsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ImageDetailsTableViewCell.identifier)
        self.tvMain.register(UINib.init(nibName: NoDataTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NoDataTableViewCell.identifier)

        self.reloadTableView()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tvMain.reloadData()
        }
    }
}

//MARK:- tableview datasource/delegates
extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.manager.getFavouriteImages().count
        return (count > 0 ? count : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.manager.getFavouriteImages().count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageDetailsTableViewCell.identifier) as! ImageDetailsTableViewCell
            cell.imageModel = self.manager.getFavouriteImages()[indexPath.row]
            cell.btnFavouriteTapped = { [weak self] in
                guard let this = self else { return }
                
                this.manager.setFavourite(date: this.manager.getFavouriteImages()[indexPath.row].getDate())
                this.reloadTableView()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataTableViewCell.identifier) as! NoDataTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = main.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        viewController.imageModel = self.manager.getFavouriteImages()[indexPath.row]

        DispatchQueue.main.async {
            self.present(viewController, animated: true)
        }
    }
}
