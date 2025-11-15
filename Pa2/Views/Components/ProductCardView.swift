import SwiftUI

struct ProductCardView: View {
    let product: Product
    var isFavorite: Bool
    var onFavoriteTapped: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                
         
                AsyncImage(url: URL(string: product.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                } placeholder: {
                    ProgressView()
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)

  
                Button(action: onFavoriteTapped) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(isFavorite ? .red : .gray)
                        .padding(8)
                        .background(.white.opacity(0.7))
                        .clipShape(Circle())
                }
                .padding(8)
            }
             

            Text(product.title)
                .font(.headline)
                .lineLimit(2)
                .padding(.top, 4)

            Text("S/ \(product.price, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.green)
           
            Spacer()
        }
        
        .frame(height: 220)
    }
}
