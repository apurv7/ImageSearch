//
//  ImageDataAccessor.swift
//  ImageSearch
//
//  Created by apurv on 07/02/2022.
//

import UIKit
import CoreData

//MARK:- singleton class for handling database operations
class DataAccessor {
    
    private static var instance: DataAccessor!
    
    fileprivate let kImageDataEntity = "ImageData"
    
    internal lazy var managedObjectContext: NSManagedObjectContext! = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    private init() {}
    
    // to get the instansce
    static func getInstance() -> DataAccessor {
        if let ins = instance {
            return ins
        }
        
        self.instance = DataAccessor()
        return self.instance
    }
    
    ///add image in database
    func saveImageInDB(_ jsonData: Data) -> ImageData? {
        do {
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve context")
            }
            
            // Parse JSON data
            let decoder = JSONDecoder()
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = self.managedObjectContext
            let imageData = try decoder.decode(ImageData.self, from: jsonData)
            if imageData.getDate().isEmpty  {
                return nil
            }
            
            //save image
            self.saveImage()
            
            //return image object
            return imageData
        } catch let error {
            print(error)
            return nil
        }
    }
    
    ///mark/unmark image as favourite
    internal func setFavourite(date: String) {
        let predicate = NSPredicate(format: "date == %@", "\(date)")
        let imageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kImageDataEntity)
        imageFetchRequest.predicate = predicate
        
        do {
            let results = try managedObjectContext.fetch(imageFetchRequest) as! [ImageData]
            if results.isEmpty {
                return
            } else {
                results[0].setFavourite()
            }
        } catch {
            print ("There was an error saving new image")
        }
        
        self.saveImage()
    }
    
    ///check if image is marked as favourite
    internal func checkFavourite(date: String) -> Bool {
        let predicate = NSPredicate(format: "date == %@", "\(date)")
        let imageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kImageDataEntity)
        imageFetchRequest.predicate = predicate
        
        do {
            let results = try managedObjectContext.fetch(imageFetchRequest) as! [ImageData]
            if results.isEmpty {
                return false
            } else {
                return results[0].isFavouriteImage()
            }
        } catch {
            print ("There was an error saving new image")
        }
        
        return false
    }
    
    ///get last 5 recent images list
    internal func getRecentImagesWithDate(alreadyDisplayedDate: String) -> [ImageData]? {
        let imageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kImageDataEntity)
        
        do {
            var results = try managedObjectContext.fetch(imageFetchRequest) as! [ImageData]
            if results.isEmpty {
                return nil
            } else {
                results = results.filter( { $0.getDate() != alreadyDisplayedDate }).reversed()
                return Array(results.prefix(5))
            }
        } catch {
            print ("There was an error saving new image")
        }
        
        return nil
    }
    
    ///get all favourites
    internal func getFavouriteImages() -> [ImageData]? {
        let imageFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kImageDataEntity)
        imageFetchRequest.predicate = NSPredicate(format: "isFavourite == YES")

        do {
            let results = try managedObjectContext.fetch(imageFetchRequest) as! [ImageData]
            if results.isEmpty {
                return nil
            } else {
                return Array(results)
            }
        } catch {
            print ("There was an error saving new image")
        }
        
        return nil
    }
    
    ///save managed object context
    private func saveImage() {
        do {
            try managedObjectContext.save()
        } catch let error {
            print ("There was an error saving new image : \(error.localizedDescription)")
        }
    }
}
