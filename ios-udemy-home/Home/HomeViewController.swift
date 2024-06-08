import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private let collectionView = HomeCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .systemBackground
        
        let uiModel = HomeUIModel(sectionModels: [
            .init(
                section: .mainBanner(id: "123"),
                body: [
                    .mainBanner(
                        id: "234",
                        imageLink: "https://images.unsplash.com/photo-1456406644174-8ddd4cd52a06?q=80&w=2048&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                        title: "any_title",
                        caption: "any_caption"
                    )
                ])
        ])
        
        collectionView.setupUIModel(uiModel: uiModel)
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

