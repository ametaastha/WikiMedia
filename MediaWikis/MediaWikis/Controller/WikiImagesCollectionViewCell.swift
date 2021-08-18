//
//  WikiImagesCollectionViewCell.swift
//  MediaWikis
//
//  Created by Astha Ameta on 8/16/21.
//

import UIKit

class WikiImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var wikiImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
         setNeedsLayout()
         layoutIfNeeded()
         return layoutAttributes
    }
    
    func configure(url: String, width: Int, height: Int) {
        wikiImageView.load(urlString: url, width: width, height: height)
        
        contentView.layer.cornerRadius = 4.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
