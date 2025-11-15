import SwiftUI

struct HomeView: View {
    @Environment(ShopViewModel.self) private var viewModel
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Header y Search
                    headerView
                    searchBar
                    
                    // MARK: - Banner
                    bannerView
                    
                    // MARK: - Products Grid
                    productsHeader
                    
           
                    if viewModel.isLoading {
                        ProgressView("Cargando productos...")
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                    
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.products) { product in
                                NavigationLink(value: product) {
                                    ProductCardView(
                                        product: product,
                                        isFavorite: viewModel.isFavorite(product: product),
                                        onFavoriteTapped: {
                                            viewModel.toggleFavorite(product: product)
                                        }
                                    )
                                    .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Tienda")
            .navigationBarHidden(true)
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
        
            .task {
               
                if viewModel.products.isEmpty {
                    await viewModel.fetchProducts()
                }
            }
        }
    }
    

    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Miraflores")
                Text("Perú").foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "bell")
                .font(.title2)
        }
        .padding(.horizontal)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            Text("Search")
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var bannerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.green)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Special offers\nfor you")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Button("Shop now") {}
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding()
                
                Image("dog")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
            }
        }
        .frame(height: 160)
        .padding(.horizontal)
    }
    
    private var productsHeader: some View {
        HStack {
            Text("Products")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
            Button("See all") {}
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
    }
}
