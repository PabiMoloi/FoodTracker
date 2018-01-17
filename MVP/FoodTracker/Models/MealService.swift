class MealService {
    // MARK: - Properties
    private var mealApi: MealApi

    init(mealApi: MealApi) {
        self.mealApi = mealApi
    }

    func loadMeals() -> [Meal]? {
        return mealApi.loadMeals()
    }

    func addMeal(meal: Meal) {
        if var meals = mealApi.loadMeals() {
            meals.append(meal)
            mealApi.saveMeals(meals: meals)
        } else {
            mealApi.saveMeals(meals: [meal])
        }
    }

    func deleteMeal(at index: Int) {
        guard var meals = mealApi.loadMeals() else {
            fatalError("Unexpected deletiton of meal")
        }

        meals.remove(at: index)
        mealApi.saveMeals(meals: meals)
    }

    func updateMeal(at index: Int, meal: Meal) {
        guard var meals = mealApi.loadMeals() else {
            fatalError("Unexpected update operation of meal")
        }

        meals[index] = meal
        mealApi.saveMeals(meals: meals)
    }
}
