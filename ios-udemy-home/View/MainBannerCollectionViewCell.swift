import SwiftUI
import SnapKit

final class MainBannerCollectionViewCell: UICollectionViewCell {
    private var hostingController: UIHostingController<MainBannerView>!
    
    func configure(
        imageLink: String,
        title: String,
        caption: String
    ) {
        guard hostingController == nil else { return }
        let mainBannerView = MainBannerView(
            imageLink: imageLink,
            title: title,
            caption: caption
        )
        hostingController = UIHostingController(rootView: mainBannerView)
        guard let hostingController = hostingController else { return }
        addSubview(hostingController.view)
        hostingController.view.clipsToBounds = true
        hostingController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
