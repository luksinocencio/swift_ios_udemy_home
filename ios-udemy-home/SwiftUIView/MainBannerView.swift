import SwiftUI

struct MainBannerView: View {
    let imageLink: String
    let title: String
    let caption: String
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: imageLink)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .clipped()
            } placeholder: {
                PlaceholderImageView()
                    .frame(height: 160)
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 24, weight: .bold, design: .serif))
                Text(caption)
                    .font(.system(size: 12))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
            }
            .padding(.leading, 20)
        }
    }
}

#Preview {
    MainBannerView(
        imageLink: "https://plus.unsplash.com/premium_photo-1661373704604-7c4d230c8928?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        title: "Learning that fits",
        caption: "Skills for your present and future"
    )
}
