struct Meal: Codable, Identifiable, Hashable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(idMeal)
         hasher.combine(strMeal) // Adicione outras propriedades relevantes
     }

     static func == (lhs: Meal, rhs: Meal) -> Bool {
         return lhs.idMeal == rhs.idMeal && lhs.strMeal == rhs.strMeal
     }
}

struct MealResponse: Codable {
    let meals: [Meal]
}
