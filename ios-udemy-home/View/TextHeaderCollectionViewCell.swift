import SnapKit
import UIKit

final class TextHeaderCollectionViewCell: UICollectionViewCell {
    var onTap: (() -> Void)?
    
    private let label = AttributedTappableLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, highlightText: String?) {
        label.setAttributedText(
            text: text,
            highlightedText: highlightText,
            color: .systemIndigo, 
            font: .systemFont(ofSize: 18, weight: .bold)
        )
    }
    
    private func layout() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        label.onTap = { [weak self] in
            self?.onTap?()
        }
    }
}
