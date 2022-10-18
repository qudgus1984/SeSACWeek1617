//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/18.
//

import UIKit

struct User {
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
        User(name: "뽀로로", age: 11),
        User(name: "에디", age: 2),
        User(name: "루비", age: 13),
        User(name: "엘리어스", age: 7)
    ]
    
    //cellForItemAt 전에 생성되어야 함. => register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        configuration.showsSeparators = false // 구분선 삭제
        configuration.backgroundColor = .brown // 배경색 변경
        
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            // content설정
            var content = UIListContentConfiguration.valueCell()
            // cell.defaultContentConfiguration()
            
            content.text = "\(itemIdentifier)"
            content.textProperties.color = .red
            
            content.secondaryText = "\(itemIdentifier.age)살"
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 20
                        
            content.image = itemIdentifier.age < 8 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.imageProperties.tintColor = .yellow
            
            cell.contentConfiguration = content
            cell.backgroundConfiguration?.backgroundColor = .black
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = list[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        
        return cell
    }

}
