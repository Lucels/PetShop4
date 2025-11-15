import SwiftUI

struct FavoritesView: View {
    @Environment(ShopViewModel.self) private var viewModel
    
    private var favoriteProducts: [Product] {
        viewModel.getFavoriteProducts()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if favoriteProducts.isEmpty {
                    Spacer()
                    Image(systemName: "heart.slash.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No tienes productos favoritos aún.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                    Spacer()
                } else {
                    List {
                        
                        ForEach(favoriteProducts) { product in
                            NavigationLink(value: product) {
                                HStack {
                                    
                                    AsyncImage(url: URL(string: product.image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text(product.title)
                                            .font(.headline)
                                        Text("S/ \(product.price, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                            }
                        }
                        
                        .onDelete { indexSet in
                            
                            for index in indexSet {
                                let product = favoriteProducts[index]
                              
                                viewModel.toggleFavorite(product: product)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favoritos")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
        }
    }
}
