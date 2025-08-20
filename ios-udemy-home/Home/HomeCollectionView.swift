import SwiftUI
import Combine

final class HomeCollectionView: UICollectionView {
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<HomeUIModel.Section, HomeUIModel.Item>!
    private var uiModel: HomeUIModel?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewLayout = makeCompositionLayout()
        registerCells()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(uiModel: HomeUIModel) {
        self.uiModel = uiModel
        self.applySnapshot()
    }
    
    private func registerCells() {
        register(
            MainBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: MainBannerCollectionViewCell.namedIdentifier
        )
        register(
            TextHeaderCollectionViewCell.self,
            forCellWithReuseIdentifier: TextHeaderCollectionViewCell.namedIdentifier
        )
        register(
            CourseCollectionViewCell.self,
            forCellWithReuseIdentifier: CourseCollectionViewCell.namedIdentifier
        )
        register(
            CategoriesCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoriesCollectionViewCell.namedIdentifier
        )
        register(
            FeaturedCourseCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedCourseCollectionViewCell.namedIdentifier
        )
        register(
            UdemyBusinessCollectionViewCell.self,
            forCellWithReuseIdentifier: UdemyBusinessCollectionViewCell.namedIdentifier
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
                    case let .textHeader(id, text, highlightedText):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextHeaderCollectionViewCell.namedIdentifier, for: indexPath) as! TextHeaderCollectionViewCell
                        cell.configure(text: text, highlightText: highlightedText)
                        cell.onTap = {
                            print(">>> textHeader link tapped: \(id) - \(highlightedText)")
                        }
                        return cell
                    case let .course(id, imageLink, title, author, rating, reviewCount, price, tag):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCollectionViewCell.namedIdentifier, for: indexPath) as! CourseCollectionViewCell
                        cell.configure(imageLink: imageLink, title: title, author: author, rating: rating, reviewCount: reviewCount, price: price, tag: tag)
                        cell.onTap = {
                            print(">>>> course tapped: \(id) - \(title)")
                        }
                        return cell
                    case let .categoryScroller(id, titles):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.namedIdentifier, for: indexPath) as! CategoriesCollectionViewCell
                        cell.configure(titles: titles)
                        cell.onTap = { title in
                            print(">>>>> categoryScroller tapped: \(id) - \(title)")
                        }
                        return cell
                    case let .featuredCourse(_, imageLink, title, author, rating, reviewCount, price):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCourseCollectionViewCell.namedIdentifier, for: indexPath) as!
                        FeaturedCourseCollectionViewCell
                        cell.configure(imageLink: imageLink, title: title, author: author, rating: rating, reviewCount: reviewCount, price: price)
                        cell.onTap = {
                            print(">>>> featuredCourse tapped: \(title)")
                        }
                        return cell
                    case let .udemyBusinessBanner(_, link):
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UdemyBusinessCollectionViewCell.namedIdentifier, for: indexPath) as! UdemyBusinessCollectionViewCell
                        cell.onTap = {
                            print(">>>> tapped on udemy Business \(link)")
                        }
                        return cell
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
                    return self?.makeBannerSectionSection()
                case .textHeader:
                    guard case let .textHeader(_, text, _) = sectionModel.body.first else {
                        return nil
                    }
                    return self?.makeTextHeaderSection(text: text)
                case .courseSwimlane:
                    return self?.makeCourseSwimlaneSection()
                case .categories:
                    return self?.makeCategoriesSection()
                case .featuredCourse:
                    return self?.makeFeaturedCourseSection()
                case .udemyBusinessBanner:
                    return self?.makeUdemyBusinessBannerSection()
                default:
                    fatalError()
            }
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: provider)
    }
    
    private func makeBannerSectionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        return section
    }
    
    private func makeTextHeaderSection(text: String) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(AttributedTappableLabel.heightForWidth(frame.size.width, text: text))
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20)
        return section
    }
    
    private func makeCourseSwimlaneSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(160),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func makeCategoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension:.absolute(88)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        return section
    }
    
    func makeFeaturedCourseSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(230)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize, subitems: [item]
        )
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        return section
    }
    
    func makeUdemyBusinessBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(230)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSize, subitems: [item]
        )
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20)
        return section
    }
}
