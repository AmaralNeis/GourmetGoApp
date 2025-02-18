struct CategoryResponse: Codable {
    let categories: [Category]
}

struct Category: Codable, Identifiable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
    
    var id: String { idCategory }
}
