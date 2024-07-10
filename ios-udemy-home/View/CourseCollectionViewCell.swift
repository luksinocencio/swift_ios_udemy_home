import SwiftUI
import SnapKit

final class CourseCollectionViewCell: UICollectionViewCell {
    private var hostingController: UIHostingController<CourseView>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        imageLink: String,
        title: String,
        author: String,
        rating: Double,
        reviewCount: Int,
        price: Decimal,
        tag: String
    ) {
        guard hostingController == nil else { return }
        
        let courseView = CourseView(
            imageLink: imageLink,
            title: title,
            author: author,
            rating: rating,
            reviewCount: reviewCount,
            price: price,
            tag: tag
        )
        
        hostingController = UIHostingController(rootView: courseView)
        addSubview(hostingController.view)
        hostingController.view.clipsToBounds = true
        hostingController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
