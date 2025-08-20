import SwiftUI
import SnapKit

final class UdemyBusinessCollectionViewCell: UICollectionViewCell {
    private var hostingController: UIHostingController<UdemyBusinessView>!
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implementend")
    }
    
    private func layout() {
        hostingController = UIHostingController(rootView: UdemyBusinessView())
        addSubview(hostingController.view)
        hostingController.view.clipsToBounds = true
        hostingController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        hostingController.rootView.onTap = { [weak self] in
            self?.onTap?()
        }
    }
}
