import SwiftUI

struct MainView: View {
    
    @State private var viewModel = ShopViewModel()

    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
            
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
            
                CartView()
                    .tabItem {
                        Label("Cart", systemImage: "cart")
                    }
            
                Text("Profile View")
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
            .environment(viewModel)

            
    
            if viewModel.showToast {
                toastView
            }
        }
    }
    
    private var toastView: some View {
        Text(viewModel.toastMessage)
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.75))
            .clipShape(Capsule())
            .padding(.bottom, 50)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.spring(), value: viewModel.showToast)
            .zIndex(1)
    }
}
