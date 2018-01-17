import UIKit

class MealTablePresenter {
    weak private var mealTableView: MealTableView?
    private var mealService: MealService
    
    private var mealsToDisplay = [MealViewData]()
    
    init(mealService: MealService) {
        self.mealService = mealService
    }
    
    var numMeals: Int {
        return mealsToDisplay.count
    }
    
    func attachView(_ view: MealTableView) {
        mealTableView = view
    }
    
    func detachView() {
        mealTableView = nil
    }
    
    func loadMeals() {
        guard let meals = mealService.loadMeals() else {
            loadSampleMeals()
            self.mealTableView?.reloadMeals()
            return
        }
        
        mealsToDisplay = meals.map {
            MealViewData(name: $0.name, photo: $0.photo, rating: $0.rating)
        }
        self.mealTableView?.reloadMeals()
    }
    
    func getMeal(at index: Int) -> MealViewData {
        return mealsToDisplay[index]
    }
    
    func addMeal(meal: MealViewData) {
        mealsToDisplay.append(meal)
        if let mappedMeal = Meal(name: meal.name, photo: meal.photo, rating: meal.rating) {
            mealService.addMeal(meal: mappedMeal)
            self.mealTableView?.addMeal()
        }
    }
    
    func deleteMeal(indexPath: IndexPath) {
        mealService.deleteMeal(at: indexPath.row)
        mealsToDisplay.remove(at: indexPath.row)
        self.mealTableView?.deleteMeal(indexPath: indexPath)
    }
    
    //MARK: - Private Methods
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        let meal1 = MealViewData(name: "Caprese Salad", photo: photo1, rating: 4)
        let meal2 = MealViewData(name: "Chicken and Potatoes", photo: photo2, rating: 5)
        let meal3 = MealViewData(name: "Pasta with Meatballs", photo: photo3, rating: 3)
        
        mealsToDisplay = [meal1, meal2, meal3]
    }
}
