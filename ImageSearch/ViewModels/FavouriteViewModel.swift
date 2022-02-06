//
//  FavouriteViewModel.swift
//  ImageSearch
//
//  Created by apurv on 07/02/2022.
//

import Foundation

class FavouriteViewModel {
    
    ///method to get all favourite images
    internal func getFavouriteImages() -> [ImageData] {
        return DataAccessor.getInstance().getFavouriteImages() ?? []
    }
    
    ///method to mark/unmark favourites
    internal func setFavourite(date: String) {
        DataAccessor.getInstance().setFavourite(date: date)
    }
}
