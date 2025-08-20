import SwiftUI

struct CourseView: View {
    let imageLink: String
    let title: String
    let author: String
    let rating: Double
    let reviewCount: Int
    let price: Decimal
    let tag: String
    
    var onTap: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: URL(string: imageLink)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .border(Color.gray.opacity(0.3))
                    .clipped()
            } placeholder: {
                PlaceholderImageView()
                    .frame(height: 64)
            }.padding(.bottom, 4)
            
            Text(title)
                .font(.system(size: 12, weight: .bold, design: .default))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(4)
            
            Text(author)
                .font(.system(size: 10, weight: .regular, design: .default))
                .foregroundStyle(.gray)
            
            ReviewRatingView(rating: rating, reviewCount: reviewCount)
            
            Text(price.priceFormat)
                .font(.system(size: 10, weight: .bold))
            
            Text(tag)
                .font(.system(size: 10, weight: .semibold))
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                .background(content: {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.yellow.opacity(0.4))
                })
            
            Spacer()
        }
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    CourseView(
        imageLink: "https://source.unsplash.com/random/?city,night",
        title: "iOS & Swift: Server Driven UI Compositional Layout & SwiftUI",
        author: "Kelvin Fok",
        rating: 4.5,
        reviewCount: 224,
        price: 19.99,
        tag: "Bestseller"
    )
}
