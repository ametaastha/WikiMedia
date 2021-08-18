//
//  WikiImagesViewModel.swift
//  MediaWikis
//
//  Created by Astha Ameta on 8/16/21.
//

import UIKit
import Foundation

class WikiImagesViewModel: NSObject {
   
    var wikiModel = [WikiModel]()
    var wikiData = [WikiData]()
    var thumbNail = [Thumbnail]()
    weak var vc: SearchViewController?
    var fileManager = FilesManager()
    var fileStoringDict = [String : [Thumbnail]]()

  
    func performRequest(searchTerm: String) {
        wikiModel.removeAll()
        let url = "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=thumbnail&pithumbsize=200&pilimit=50&generator=prefixsearch&gpssearch=\(searchTerm)"
        
        let semaphore = DispatchSemaphore(value: 0)
        if let request = URL(string: url) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request, completionHandler: { [self] (data, response, error) -> Void in
                if (error != nil) {
                    semaphore.signal()
                }
                else {
                    if let safeData = data {
                        do {
                            let decoder = JSONDecoder()
                            let decodedData = try decoder.decode(WikiData.self, from: safeData)
                            print(decodedData)
                            self.wikiData.append(contentsOf: [decodedData])
                            for item in decodedData.query.pages.values {
                                if let thumbnail = item.thumbnail {
                                    let wm = WikiModel(thumbnail)
                                    self.wikiModel.append(wm)
                                    self.thumbNail.append(thumbnail)
                                    fileStoringDict[searchTerm] = self.thumbNail
                                    let jsonData = try? JSONEncoder().encode(fileStoringDict)
                                    try! fileManager.save(fileNamed: "MediaWikis", data: jsonData!)
                                    
                                    DispatchQueue.main.async {
                                        self.vc?.wikiImagesCollectionView.reloadData()
                                    }
                                }
                            }
                            print(self.thumbnail)
                        }
                        catch {
                            print(error)
                        }
                    }
                    let httpResponse = response as! HTTPURLResponse
                    debugPrint(httpResponse as Any)
                    semaphore.signal()
                }
            })
            dataTask.resume()
            _ = semaphore.wait(timeout: .distantFuture)
        }
    }
    
    func numberOfImages() -> Int {
        return wikiModel.count
    }
    
    func thumbnail(atIndex index: Int) -> WikiModel {
        return wikiModel[index]
    }
}

extension UIImageView {
    func load(urlString: String, width: Int, height: Int) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [self] in
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func scaleImageToSize(img: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    
}
