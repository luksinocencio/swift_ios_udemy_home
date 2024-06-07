import SwiftUI

struct PlaceholderImageView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.gray).opacity(0.3)
    }
}

#Preview {
    PlaceholderImageView()
}
