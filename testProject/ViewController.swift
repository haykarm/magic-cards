//
//  ViewController.swift
//  testProject
//
//  Created by Hayk Hartynyan on 11/10/19.
//  Copyright © 2019 Hayk Hartynyan. All rights reserved.
//

import UIKit

let emptyFieldText = "***Search some magic***"
let notFoundText = "The magic is not found"

enum EmptyState {
    case empty
    case notFound
}

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptySateImageView: UIImageView!
    @IBOutlet weak var emptyStateLable: UILabel!
    
    var cardModels: [CardModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: "cardCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 205
        searchBar.delegate = self
        showEmptyView(.empty)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    public func updateCards(_ cardType: String?) {
        guard let cardType = cardType, cardType.count > 0 else {
            showEmptyView(.empty)
            return
        }
        let url = URL(string: "https://api.scryfall.com/cards/search?q=t%3A\(cardType.lowercased())")!
        
        NetworkService.getRequest(url) { (json) in
            guard let json = json else {
                self.showEmptyView(.notFound)
                return
            }
            
            if let cards = json["data"] as? [[String : Any]] {
                self.cardModels = []
                guard cards.count != 0 else {
                    self.showEmptyView(.notFound)
                    return
                }
                for cardData in cards {
                    self.cardModels?.append(CardModel(cardData))
                }
                
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: false)
                }
            } else {
                self.showEmptyView(.notFound)
            }
        }
    }
    
    private func showEmptyView(_ state: EmptyState) {
        tableView.isHidden = true
        emptyStateLable.text = state == EmptyState.empty ? emptyFieldText : notFoundText
        emptySateImageView.image = UIImage(named:state == EmptyState.empty ? "magic-cards" : "magic-not-found")
    }
    
    @objc private func handleTap() {
        searchBar.endEditing(true)
    }
}



extension ViewController: UISearchBarDelegate {
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateCards(searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)

    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardModels?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardTableViewCell

        cell.setup(cardModels?[indexPath.row])

        if cardModels?[indexPath.row].image == nil, let imageURI = cardModels?[indexPath.row].imageURI, let imageURL = URL(string: imageURI) {
            NetworkService.downloadImage(url: imageURL) { (image) in
                self.cardModels?[indexPath.row].image = image
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

