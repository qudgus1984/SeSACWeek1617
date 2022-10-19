//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/18.
//

import UIKit

struct User: Hashable {
    let id = UUID().uuidString
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class SimpleCollectionViewController: UICollectionViewController {
    
    //var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    
    var list = [
        User(name: "뽀로로", age: 2),
        User(name: "뽀로로", age: 2),
        User(name: "루비", age: 13),
        User(name: "엘리어스", age: 7)
    ]
    
    //cellForItemAt 전에 생성되어야 함. => register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        
        //1. Identifier 2. struct 장점
        
        // 셀 1개당 한번씩 실행
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            // content설정
            var content = UIListContentConfiguration.valueCell()
            // cell.defaultContentConfiguration()
            
            content.text = "\(itemIdentifier.name)"
            content.textProperties.color = .red
            
            content.secondaryText = "\(itemIdentifier.age)살"
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 20
                        
            content.image = itemIdentifier.age < 8 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            
            if indexPath.item < 3 {
                content.imageProperties.tintColor = .yellow
            }
                                                                                                    
            cell.contentConfiguration = content
//            cell.backgroundConfiguration?.backgroundColor = .black
            
//            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
//            backgroundConfig.backgroundColor = .lightGray
//            backgroundConfig.cornerRadius = 10
//            backgroundConfig.strokeWidth = 2
//            backgroundConfig.strokeColor = .systemPink
//            cell.backgroundConfiguration = backgroundConfig
            
            cell.backgroundConfiguration = self.backgroundSetting()
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)

        
        
    }

}

extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        //14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        //컬렉션뷰 스타일 (컬렉션뷰 셀 X)
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false // 구분선 삭제
        configuration.backgroundColor = .brown // 배경색 변경
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
        return layout
    }
}

extension SimpleCollectionViewController {
    
    private func backgroundSetting() -> UIBackgroundConfiguration {
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .lightGray
        backgroundConfig.cornerRadius = 10
        backgroundConfig.strokeWidth = 2
        backgroundConfig.strokeColor = .systemPink
        return backgroundConfig
    }
}
