//
//  File.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    var viewModel = NewsViewModel()
    let disposeBag = DisposeBag()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierachy()
        configureDataSource()
        bindData()
//        configureViews()
    }
    
    
    func bindData() {

        
        viewModel.sample
            .withUnretained(self)
            .bind { (vc, item) in
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(item)
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
            .disposed(by: disposeBag)
        
        loadButton
            .rx
            .tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.loadSample()
            }
            .disposed(by: disposeBag)
        
        resetButton
            .rx
            .tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.resetSample()
            }
            .disposed(by: disposeBag)
    }
    

    
//    func configureViews() {
//        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
////        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
////        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
//    }
//
//    @objc func numberTextFieldChanged() {
//        print(#function)
//        guard let text = numberTextField.text else { return }
//        viewModel.changePageNumberFormat(text: text)
//    }
//
//    @objc func resetButtonTapped() {
//        viewModel.resetSample()
//    }
//
//    @objc func loadButtonTapped() {
//        viewModel.loadSample()
//    }
}

extension NewsViewController {
    
    func configureHierachy() { //addSubView, init, snapkit
        collectionView.collectionViewLayout = createLayOut()
        collectionView.backgroundColor = .lightGray
        
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, IndexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(News.items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayOut() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
