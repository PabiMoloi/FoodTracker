import Quick
import Nimble
@testable import FoodTracker

class MealApiMock: MealApi {
    var loadMealsCalled = false
    var receivedMeals: [Meal]?

    override func loadMeals() -> [Meal]? {
        loadMealsCalled = true
        return [
            Meal(name: "banana", photo: nil, rating: 1)!,
            Meal(name: "apple", photo: nil, rating: 2)!,
            Meal(name: "orange", photo: nil, rating: 3)!
        ]
    }

    override func saveMeals(meals: [Meal]) {
        receivedMeals = meals
        super.saveMeals(meals: meals)
    }
}

class MealServiceSpec: QuickSpec {
    override func spec() {
        describe("MealServiceSpec") {
            var mealApiMock: MealApiMock!
            var mealService: MealService!

            beforeEach {
                mealApiMock = MealApiMock()
                mealService = MealService(mealApi: mealApiMock)
            }

            describe("addMeal") {
                it("appends a new meal") {
                    let newMeal = Meal(name: "strawberry", photo: nil, rating: 4)!
                    mealService.addMeal(meal: newMeal)
                    expect(mealApiMock.loadMealsCalled).to(beTruthy())
                    expect(mealApiMock.receivedMeals?.count).to(equal(4))
                }
            }

            describe("deleteMeal") {
                it("removes a meal") {
                    mealService.deleteMeal(at: 1)
                    let savedMealNames = mealApiMock.receivedMeals!.map { $0.name }
                    expect(savedMealNames).to(equal(["banana", "orange"]))
                }
            }
        }
    }
}
