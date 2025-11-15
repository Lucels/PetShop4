import Foundation
import SwiftUI

struct CartItem: Identifiable, Equatable {
    let id = UUID()
    var product: Product
    var quantity: Int
}

@MainActor
@Observable
class ShopViewModel {

   
    var products: [Product] = []
    var isLoading: Bool = false
    var errorMessage: String?
    

    private let apiURL = "https://petapi-591531460223.us-central1.run.app/api/products"
    
    var cartItems: [CartItem] = []
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    

    private let favoritesKey = "myFavoriteProductIDs"
    var favoriteProductIDs: Set<Int> = []
    

    var showToast: Bool = false
    var toastMessage: String = ""
    
    init() {

        loadFavorites()
    }


    func addToCart(product: Product, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += quantity
        } else {
            cartItems.append(CartItem(product: product, quantity: quantity))
        }
    }
    
    func updateQuantity(item: CartItem, newQuantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            if newQuantity > 0 {
                cartItems[index].quantity = newQuantity
            } else {
                cartItems.remove(at: index)
            }
        }
    }
        
    func isFavorite(product: Product) -> Bool {
        favoriteProductIDs.contains(product.id)
    }

    func toggleFavorite(product: Product) {
        if isFavorite(product: product) {
            favoriteProductIDs.remove(product.id)
            
            showToast(message: "Se quitó de favoritos")
            
            print("Se quitó de favoritos (ID: \(product.id) - \(product.title))")
            
        } else {
            favoriteProductIDs.insert(product.id)
            
            print("Se añadió a favoritos (ID: \(product.id) - \(product.title))")
        }
        

        saveFavorites()
    }
    
    func getFavoriteProducts() -> [Product] {
        products.filter { product in
            favoriteProductIDs.contains(product.id)
        }
    }
    
    private func saveFavorites() {

        let idArray = Array(self.favoriteProductIDs)
        UserDefaults.standard.set(idArray, forKey: favoritesKey)
        print("Favoritos guardados en el dispositivo.")
    }
    
    private func loadFavorites() {
    
        let savedIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        
        self.favoriteProductIDs = Set(savedIDs)
        print("Favoritos cargados: \(self.favoriteProductIDs.count) IDs encontrados.")
    }
    
    func showToast(message: String) {
        self.toastMessage = message
        self.showToast = true
        
        Task {
          
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
          
            await MainActor.run {
                self.showToast = false
            }
        }
    }
        
    func fetchProducts() async {
        guard !isLoading else { return }
        
        print("Empezando a cargar productos...")
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: apiURL) else {
            errorMessage = "URL inválida"
            isLoading = false
            print("Error: URL inválida")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            let apiResponse = try decoder.decode(APIResponse.self, from: data)
            
            self.products = apiResponse.results
            
            self.isLoading = false
            print("¡Productos cargados exitosamente! Se encontraron \(apiResponse.count) productos.")
            
        } catch {
            errorMessage = "Error al obtener los datos: \(error.localizedDescription)"
            isLoading = false
            print("Error al decodificar: \(error)")
        }
    }
}
