import SwiftUI

struct ProductDetailView: View {
    @Environment(ShopViewModel.self) private var viewModel
    let product: Product
    @State private var quantity = 1
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: product.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 300)
            .padding()
             
            
            Text(product.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("S/ \(product.price, specifier: "%.2f")")
                .font(.title)
                .foregroundColor(.green)
                .padding()

            
            HStack {
                Button { if quantity > 1 { quantity -= 1 } } label: { Image(systemName: "minus.circle") }
                Text("\(quantity)")
                    .font(.title2)
                    .frame(width: 50)
                Button { quantity += 1 } label: { Image(systemName: "plus.circle") }
            }
            .font(.largeTitle)
            .padding()

            Spacer()
            
            
            HStack {
                Button(action: {
                    viewModel.toggleFavorite(product: product)
                }) {
                    Image(systemName: viewModel.isFavorite(product: product) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite(product: product) ? .red : .gray)
                        .padding()
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                .font(.title)

                Button(action: {
                    viewModel.addToCart(product: product, quantity: quantity)
                }) {
                    Text("Add to Cart")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(20)
                }
                .font(.title2)
            }
            .padding()
        }
        .navigationTitle("Detalle del Producto")
        .navigationBarTitleDisplayMode(.inline)
    }
}

