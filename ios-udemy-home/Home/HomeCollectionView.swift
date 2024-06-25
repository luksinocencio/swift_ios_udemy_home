import SwiftUI
import Combine

final class HomeCollectionView: UICollectionView {
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<HomeUIModel.Section, HomeUIModel.Item>!
    private var uiModel: HomeUIModel?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewLayout = makeCompositionLayout()
        setup()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUIModel(uiModel: HomeUIModel) {
        self.uiModel = uiModel
        self.applySnapshot()
    }
    
    private func setup() {
        register(
            MainBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: MainBannerCollectionViewCell.namedIdentifier
        )
        register(
            TextHeaderCollectionViewCell.self,
            forCellWithReuseIdentifier: TextHeaderCollectionViewCell.namedIdentifier
        )
    }
    
    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(
            collectionView: self,
            cellProvider: { collectionView, indexPath, item in
                switch item {
                case let .mainBanner(_, imageLink, title, caption):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainBannerCollectionViewCell.namedIdentifier, for: indexPath) as! MainBannerCollectionViewCell
                    cell.configure(imageLink: imageLink, title: title, caption: caption)
                    return cell
                case let .textHeader(_, text, highlightedText):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextHeaderCollectionViewCell.namedIdentifier, for: indexPath) as! TextHeaderCollectionViewCell
                    cell.configure(text: text, highlightText: highlightedText)
                    return cell
                default:
                    fatalError()
                }
            }
        )
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeUIModel.Section, HomeUIModel.Item>()
        uiModel?.sectionModels.forEach({ sectionModel in
            snapshot.appendSections([sectionModel.section])
            snapshot.appendItems(sectionModel.body, toSection: sectionModel.section)
        })
        
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func makeCompositionLayout() -> UICollectionViewCompositionalLayout {
        let provider: UICollectionViewCompositionalLayoutSectionProvider = { [weak self] index, env in
            guard let sectionModel = self?.uiModel?.sectionModels[index] else { return nil }
            switch sectionModel.section {
            case .mainBanner:
                return self?.makeBannerSection()
            case .textHeader:
                return self?.makeTextHeaderSection()
            default:
                fatalError()
            }
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: provider)
    }
    
    private func makeBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
    
    private func makeTextHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20)
        return section
    }
}
