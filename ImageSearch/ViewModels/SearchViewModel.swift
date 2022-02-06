//
//  HomeViewModel.swift
//  ImageSearch
//
//  Created by apurv on 06/02/2022.
//

import Foundation

class SearchViewModel {
    
    ///image object
    var imageModel: ImageData?
    
    ///tableview cells array
    var cells: [CellType] = []
    
    ///variable that checksif there is  no data added yet
    var isNoDataPresent: Bool {
        get {
            if (self.imageModel == nil && self.getRecentlySavedImages().count == 0) {
                return true
            }
            
            return false
        }
    }
    
    ///method which fetches api data from date
    internal func getImageData(date: String, onCompletion: @escaping () -> ()) {
        ImageAPIHandler.getInstance().getImageData(date: date) { [weak self] (data) in
            
            guard let this = self, let data = data else {
                return
            }
            
            this.imageModel = DataAccessor.getInstance().saveImageInDB(data)
            onCompletion()
        }
    }
    
    ///method to get recently saved images
    internal func getRecentlySavedImages() -> [ImageData] {
        return DataAccessor.getInstance().getRecentImagesWithDate(alreadyDisplayedDate: self.imageModel?.getDate() ?? "") ?? []
    }
    
    ///method to mark/unmark favourites
    internal func setFavourite(date: String) {
        DataAccessor.getInstance().setFavourite(date: date)
    }
}
