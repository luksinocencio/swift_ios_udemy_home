import SwiftUI

struct UdemyBusinessView: View {
    var onTap: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Top companies trust Udemy")
                .font(.system(size: 18, weight: .bold, design: .serif))
                .padding(.top, 16)
            HStack(spacing: 40) {
                UdemyBusinessIconView(systemName: "apple.logo")
                UdemyBusinessIconView(systemName: "shazam.logo.fill")
                UdemyBusinessIconView(systemName: "playstation.logo")
            }
            Button {
                self.onTap?()
            } label: {
                Text("Try Udemy Business")
                    .font(.system(size: 12, weight: .bold))
            }
            .tint(.indigo)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity)
        .border(Color(uiColor: .systemGray))
    }
}

struct UdemyBusinessIconView: View {
    let systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 48, height: 48)
            .foregroundStyle(Color(uiColor: .gray))
    }
}

#Preview {
    UdemyBusinessView()
}
