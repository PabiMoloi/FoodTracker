import UIKit

class MealPresenter {
    weak private var mealView: MealView?
    private var meal: MealViewData?
    private var mealService: MealService
    
    init(mealService: MealService) {
        self.mealService = mealService
    }
    
    func attachView(_ view: MealView) {
        mealView = view
    }
    
    func detachView() {
        mealView = nil
    }
    
    func addMeal(name: String, photo: UIImage?, rating: Int) {
        guard let meal = Meal(name: name, photo: photo, rating: rating) else {
            return
        }
        
        mealService.addMeal(meal: meal)
    }
    
    func updateMeal(at index: Int, name: String, photo: UIImage?, rating: Int) {
        guard let meal = Meal(name: name, photo: photo, rating: rating) else {
            return
        }
        
        mealService.updateMeal(at: index, meal: meal)
    }
}
