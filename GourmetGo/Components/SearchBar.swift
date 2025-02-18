import SwiftUI

struct SearchBar: View {
    @State private var searchText: String = ""
    let onSearch: (String) -> Void

    var body: some View {
        HStack {
            TextField("Search for a recipe...", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .onSubmit {
                    onSearch(searchText)
                }
            
            Button(action: {
                onSearch(searchText)
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
}
