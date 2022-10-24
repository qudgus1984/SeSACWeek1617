import UIKit

class DiffableRandomPhotoCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = DiffableRandomPhotoViewModel()
    
    
    //Int : section String: Data
    private var dataSource: UICollectionViewDiffableDataSource<Int, RandomUser>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self
                
        viewModel.photoList.bind { photo in
            //Initial
            var snapshot = NSDiffableDataSourceSnapshot<Int, RandomUser>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo.user)
            self.dataSource.apply(snapshot)
        }
        viewModel.requestRandomhPhoto(query: "random")
    }
}
extension DiffableRandomPhotoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
extension DiffableRandomPhotoCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistertion = UICollectionView.CellRegistration<UICollectionViewListCell, RandomUser>(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.totalLikes)"
            
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

    
    
