//
//  SearchViewController.swift
//  MediaWikis
//
//  Created by Astha Ameta on 8/16/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var wikiImagesCollectionView: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive = false
    var filtered:[String] = []
    var viewModel: WikiImagesViewModel!
    var fm = FilesManager()
    var thumbNail = [Thumbnail]()
    var wikiModel = [WikiModel]()
    var arrayOfThumbnail = [[String: Any]]()
    var doesFileContainsData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchUI()
        
        let nibName = UINib(nibName: "WikiImagesCollectionViewCell", bundle:nil)
        wikiImagesCollectionView.register(nibName, forCellWithReuseIdentifier: "WikiImagesCollectionViewCell")
    
        viewModel = WikiImagesViewModel()
    }
    
    func setupSearchUI() {
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Image here..."
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.tintColor = UIColor.red
        navigationItem.titleView = searchController.searchBar
    }
}

extension SearchViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if doesFileContainsData {
            return arrayOfThumbnail.count
        }
        else {
            return viewModel.numberOfImages()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WikiImagesCollectionViewCell", for: indexPath) as! WikiImagesCollectionViewCell
        if doesFileContainsData {
            let wm = arrayOfThumbnail[indexPath.row]
            cell.configure(url: wm["source"] as! String, width: wm["width"] as! Int, height: wm["height"] as! Int)
        }
        else {
            let wm = self.viewModel.thumbnail(atIndex: indexPath.row)
            cell.configure(url: wm.source, width: wm.width, height: wm.height)
        }

        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(identifier: "ImageVC") as! ImageViewController
        if doesFileContainsData {
            detailsVC.arrayOfThumbnail = self.arrayOfThumbnail[indexPath.row]
        }
        else {
            detailsVC.wikiMdl = self.viewModel.thumbnail(atIndex: indexPath.row)
        }
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let itemWidth = (screenWidth-40)/2
        let itemHeight = (screenHeight-40)/3
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.resignFirstResponder()
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.wikiModel.removeAll()
        self.wikiImagesCollectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            arrayOfThumbnail.removeAll()
            wikiModel.removeAll()
            wikiImagesCollectionView.reloadData()
        }
                   
        if let dataFromFile = try? fm.read(fileNamed: "MediaWikis") {
            
            if dataFromFile.isEmpty {
                doesFileContainsData = false
                viewModel.performRequest(searchTerm: searchText)
                self.wikiImagesCollectionView.reloadData()
                print("No Data")
            }
            else {
                doesFileContainsData = true
                
                if let json = try? JSONSerialization.jsonObject(with: dataFromFile, options: []) {
                    print("JSONData \(json)")
                    print(type(of: json))
                    let dictionary = json as? [String: Any]
                    if let dict = dictionary {
                        if dict[searchText] != nil {
                            arrayOfThumbnail = ((dict[searchText] as? [[String: Any]])!)
                        }
                        else {
                            doesFileContainsData = false
                            viewModel.performRequest(searchTerm: searchText)
                        }
                    }
                    else {
                        viewModel.performRequest(searchTerm: searchText)
                    }
                    self.wikiImagesCollectionView.reloadData()
                }
            }
        }
    }
}

