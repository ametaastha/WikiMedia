//
//  ImageViewController.swift
//  MediaWikis
//
//  Created by Astha Ameta on 8/16/21.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var detailedImageView: UIImageView!

    var wikiMdl: WikiModel!
    var arrayOfThumbnail = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayImage()
    }
    
    func displayImage() {
        if(arrayOfThumbnail.count > 0){
            detailedImageView.load(urlString: arrayOfThumbnail["source"] as! String, width: arrayOfThumbnail["width"] as! Int, height: arrayOfThumbnail["height"] as! Int)
        }
        else {
            detailedImageView.load(urlString: wikiMdl.source, width: wikiMdl.width, height: wikiMdl.height)
        }
    }
}
