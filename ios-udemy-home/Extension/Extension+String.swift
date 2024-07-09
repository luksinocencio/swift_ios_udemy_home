import Foundation

extension String {
    var withBrackets: String {
        String(format: "(%@)", self)
    }
}
