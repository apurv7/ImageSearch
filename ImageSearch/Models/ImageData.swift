//
//  Favourites.swift
//  ImageSearch
//
//  Created by apurv on 07/02/2022.
//

import Foundation
import CoreData

class ImageData: NSManagedObject, Decodable {
    
    @NSManaged fileprivate var title : String?
    @NSManaged fileprivate var desc : String?
    @NSManaged fileprivate var date : String?
    @NSManaged fileprivate var imageUrl : String?
    @NSManaged fileprivate var isFavourite : Bool
    
    enum CodingKeys: String, CodingKey {
        case title, date
        case desc = "explanation"
        case imageUrl = "url"
        case isFavourite
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "ImageData", in: managedObjectContext) else {
            fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.desc = try container.decodeIfPresent(String.self, forKey: .desc)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.isFavourite = false
    }
    
    func setFavourite() {
        self.isFavourite = !(self.isFavourite)
    }
    
    func isFavouriteImage() -> Bool{
        return self.isFavourite
    }
    
    func getTitle() -> String {
        return self.title ?? ""
    }
    
    func getDate() -> String {
        return self.date ?? ""
    }
    
    func getDesc() -> String {
        return self.desc ?? ""
    }
    
    func getUrl() -> String {
        return self.imageUrl ?? ""
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
