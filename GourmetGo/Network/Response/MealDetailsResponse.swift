struct MealDetailsResponse: Codable {
    let meals: [MealDetails]
}

struct MealDetails: Identifiable, Codable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let ingredients: [(String, String)]
    
    var id: String {idMeal}

    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strInstructions, strMealThumb
    }
    
    init(idMeal: String, strMeal: String, strInstructions: String, strMealThumb: String, ingredients: [(String, String)] = []) {
         self.idMeal = idMeal
         self.strMeal = strMeal
         self.strInstructions = strInstructions
         self.strMealThumb = strMealThumb
         self.ingredients = ingredients
     }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try values.decode(String.self, forKey: .idMeal)
        strMeal = try values.decode(String.self, forKey: .strMeal)
        strInstructions = try values.decode(String.self, forKey: .strInstructions)
        strMealThumb = try values.decode(String.self, forKey: .strMealThumb)

        var ingredients: [(String, String)] = []
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measureKey = "strMeasure\(i)"
            
            if let ingredient = try dynamicContainer.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: ingredientKey)!),
               let measure = try dynamicContainer.decodeIfPresent(String.self, forKey: DynamicCodingKeys(stringValue: measureKey)!),
               !ingredient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               !measure.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ingredients.append((ingredient, measure))
            }
        }
        self.ingredients = ingredients
    }

}


struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    
    var intValue: Int? { nil }
    init?(intValue: Int) { nil }
}
