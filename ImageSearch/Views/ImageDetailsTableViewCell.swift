//
//  ImageDetailsTableViewCell.swift
//  ImageSearch
//
//  Created by apurv on 06/02/2022.
//

import UIKit

class ImageDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivPic: UIImageView!
    @IBOutlet weak var btnFavourite: UIButton!
    
    static let identifier = "ImageDetailsTableViewCell"
    
    var btnFavouriteTapped: (() -> Void)?
    
    var imageModel: ImageData! {
        didSet {
            self.lblTitle.text = imageModel.getTitle()
            self.lblDate.text = imageModel.getDate()
            self.ivPic.loadImageUsingCache(withUrl: imageModel.getUrl())
            
            if imageModel.isFavouriteImage() {
                self.btnFavourite.setImage(UIImage(named: "favourite"), for: .normal)
            } else {
                self.btnFavourite.setImage(UIImage(named: "favourite_alt"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.ivPic.layer.cornerRadius = 4
        self.ivPic.clipsToBounds = true
    }
    
    @IBAction func btnFavPressed() {
        self.btnFavouriteTapped?()
    }
}
