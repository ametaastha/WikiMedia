//
//  WikiModel.swift
//  MediaWikis
//
//  Created by Astha Ameta on 8/16/21.
//

import Foundation

class WikiModel: NSObject {
    
    private var thumbnail: Thumbnail
    
    init(_ thumbnail: Thumbnail) {
        self.thumbnail = thumbnail
    }
        
    var source: String {
        get {
            return self.thumbnail.source
        }
    }
    
    var width: Int {
        get {
            return self.thumbnail.width
        }
    }
    
    var height: Int {
        get {
            return self.thumbnail.height
        }
    }
}
