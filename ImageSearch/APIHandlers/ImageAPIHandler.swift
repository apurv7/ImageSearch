//
//  ImageAPIHandler.swift
//  ImageSearch
//
//  Created by apurv on 06/02/2022.
//

import Foundation

//MARK:- singleton class
class ImageAPIHandler {
    
    private static var instance: ImageAPIHandler!
    
    private init() {}
    
    // to get the instansce
    static func getInstance() -> ImageAPIHandler {
        if let ins = instance {
            return ins
        }
        
        self.instance = ImageAPIHandler()
        return self.instance
    }
    
    // api call to get the weather data
    func getImageData(date: String, onCompletion: @escaping (Data?) -> ()) {
        
        let apiURL = "https://api.nasa.gov/planetary/apod?api_key=\(Constants.apiKey)&date=\(date)"

        let session = URLSession(configuration: .default)   //session creation
        
        let _ = session.dataTask(with: URL(string: apiURL)!) { (data, response, error) in
            
            if let data = data {
                onCompletion(data)
            } else {
                onCompletion(nil)
            }
        }.resume()
    }
}
