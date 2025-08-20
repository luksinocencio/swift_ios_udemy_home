import SwiftUI
import SnapKit

final class CategoriesCollectionViewCell: UICollectionViewCell {
    private var hostingController: UIHostingController<CategoriesView>!
    
    var onTap: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(titles: [String]) {
        guard hostingController == nil else { return }
        let categoriesView = CategoriesView(titles: titles)
        hostingController = UIHostingController(rootView: categoriesView)
        addSubview(hostingController.view)
        hostingController.view.clipsToBounds = true
        hostingController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        hostingController.rootView.onTap = { [weak self] title in
            self?.onTap?(title)
        }
    }
}
