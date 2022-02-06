//
//  DetailsViewController.swift
//  ImageSearch
//
//  Created by apurv on 07/02/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivPic: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    
    var imageModel: ImageData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }
}

extension DetailsViewController {
    
    private func setupUI() {
        self.lblTitle.text = imageModel?.getTitle() ?? ""
        self.lblDesc.text = imageModel?.getDesc() ?? ""
        
        if (self.imageModel?.isFavouriteImage() ?? false) {
            self.btnFavourite.setImage(UIImage(named: "favourite"), for: .normal)
        } else {
            self.btnFavourite.setImage(UIImage(named: "favourite_alt"), for: .normal)
        }
        
        self.ivPic.loadImageUsingCache(withUrl: self.imageModel?.getUrl() ?? "")
        
        self.ivPic.layer.cornerRadius = 4
        self.ivPic.clipsToBounds = true
    }
}
