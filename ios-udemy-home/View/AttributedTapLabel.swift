import UIKit

class AttributedTappableLabel: UILabel {
  var onTap: (() -> Void)?
  var tapRange: NSRange?
  var labelFont: UIFont?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Enable user interaction to handle tap
    isUserInteractionEnabled = true
    numberOfLines = 0
    
    // Add tap gesture recognizer
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
    addGestureRecognizer(tapGesture)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func labelTapped(sender: UITapGestureRecognizer) {
    guard let tapRange = tapRange else { return }
    
    let labelSize = bounds.size
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize(width: labelSize.width, height: CGFloat.greatestFiniteMagnitude))
    let textStorage = NSTextStorage(attributedString: attributedText!)
    
    // Add textContainer to layoutManager and textStorage
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    
    // Find tapped character index
    let locationOfTouchInLabel = sender.location(in: self)
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                      y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
    let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                 y: locationOfTouchInLabel.y - textContainerOffset.y)
    let characterIndex = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    
    // Check if tapped character index is within the tapRange
    if NSLocationInRange(characterIndex, tapRange) {
      onTap?()
    }
  }
  
  func setAttributedText(text: String, highlightedText: String?, color: UIColor = .black, font: UIFont = .systemFont(ofSize: 18, weight: .bold)) {
    let attributedString = NSMutableAttributedString(string: text)
    
    // Check if highlighted string is provided
    if let highlighted = highlightedText {
      // Find the range of the highlighted part
      let range = (text as NSString).range(of: highlighted)
      
      // Apply the color to the range
      attributedString.addAttribute(.foregroundColor, value: color, range: range)
    }
    
    attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.count))
    
    self.attributedText = attributedString
    self.tapRange = (text as NSString?)?.range(of: highlightedText ?? "")
    self.labelFont = font
  }
  
  init(text: String, font: UIFont) {
    super.init(frame: .zero)
    numberOfLines = 0
    setAttributedText(text: text, highlightedText: "", color: .clear, font: font)
  }
  
    static func heightForWidth(
        _ width: CGFloat,
        font: UIFont = .systemFont(ofSize: 18, weight: .bold),
        text: String
    ) -> CGFloat {
    let size = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingRect = NSString(string: text).boundingRect(
      with: size,
      options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: font],
      context: nil
    )
    let safePadding: CGFloat = 4
    return boundingRect.height + safePadding
  }
}
