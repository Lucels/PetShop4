import SwiftUI

struct CartView: View {
    @Environment(ShopViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.cartItems.isEmpty {
                    Spacer()
                    Image(systemName: "cart.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Tu carrito está vacío.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.cartItems) { item in
                            HStack {
                               
                                AsyncImage(url: URL(string: item.product.image)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                               
                                VStack(alignment: .leading) {
                                    
                                    Text(item.product.title)
                                        .font(.headline)
                                    Text("S/ \(item.product.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                
                                HStack(spacing: 8) {
                                    Button {
                                        viewModel.updateQuantity(item: item, newQuantity: item.quantity - 1)
                                    } label: {
                                        Image(systemName: "minus")
                                            .font(.caption)
                                            .padding(5)
                                            .background(Color(.systemGray6))
                                            .clipShape(Circle())
                                    }
                                    
                                    Text("\(item.quantity)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Button {
                                        viewModel.updateQuantity(item: item, newQuantity: item.quantity + 1)
                                    } label: {
                                        Image(systemName: "plus")
                                            .font(.caption)
                                            .padding(5)
                                            .background(Color(.systemGray6))
                                            .clipShape(Circle())
                                    }
                                }
                                .foregroundColor(.black)
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: removeItems)
                    }
                    .listStyle(.plain)
                    
                    
                    VStack {
                        Divider()
                            .padding(.vertical, 5)
                       
                        HStack {
                            Text("Total")
                                .font(.title2)
                                .fontWeight(.medium)
                            Spacer()
                            Text("S/ \(viewModel.totalPrice, specifier: "%.2f")")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding(.bottom, 15)
                         
                        Button(action: {
                            print("Proceder al pago!")
                        }) {
                            Text("Check out")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .background(Color.white)
                    .shadow(radius: 5, x: 0, y: -5)
                }
            }
            .navigationTitle("Carrito")
            .background(Color(.systemGray6).ignoresSafeArea())
        }
    }
    
    
    func removeItems(at offsets: IndexSet) {
        viewModel.cartItems.remove(atOffsets: offsets)
    }
}

