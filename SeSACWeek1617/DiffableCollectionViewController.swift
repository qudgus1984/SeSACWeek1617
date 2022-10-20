//
//  DiffableCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/19.
//

import UIKit
import Kingfisher

class DiffableCollectionViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = DiffableViewModel()
    
    var list = ["아이폰", "맥북", "아이패드", "애플 워치", "에어팟"]
    
    //Int : section String: Data
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        APIService.searchPhoto(query: "apple")

        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self
        
        searchBar.delegate = self
        
        viewModel.photoList.bind { photo in
            //Initial
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
            snapshot.appendSections([0])
            snapshot.appendItems(SearchResult)
            dataSource.apply(snapshot)
            
        }
        
    }
    
}

extension DiffableCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
//        let alert = UIAlertController(title: item, message: "클릭!", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "확인", style: .cancel)
//        alert.addAction(ok)
//        present(alert, animated: true)
    }
}

extension DiffableCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.requestSearchPhoto(query: searchBar.text!)
    }
    
}

extension DiffableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistertion = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)!
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    cell.contentConfiguration = content
                }
            }
            
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .brown
            cell.backgroundConfiguration = background
        })
        
        //collectionView.dataSource = self 역할
        //numberOfItemInSection, cellForItemAt
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistertion, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}