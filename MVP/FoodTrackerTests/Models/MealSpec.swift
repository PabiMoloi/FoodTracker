import Quick
import Nimble
@testable import FoodTracker

class MealSpec: QuickSpec {
    override func spec() {
        describe("Initialization") {
            it("fails to initialize when name is empty") {
                expect(Meal(name: "", photo: nil, rating: 1)).to(beNil())
            }

            context("rating is not between 0 and 5") {
                it("fails to initialize") {
                    expect(Meal(name: "bread", photo: nil, rating: -1)).to(beNil())
                }

                it("fails to initialize") {
                    expect(Meal(name: "bread", photo: nil, rating: 6)).to(beNil())
                }
            }

            context("rating is between 0 and 5") {
                it("succeeds initialization") {
                    expect(Meal(name: "bread", photo: nil, rating: 0)).toNot(beNil())
                }

                it("succeeds initialization") {
                    expect(Meal(name: "bread", photo: nil, rating: 5)).toNot(beNil())
                }
            }
        }
    }
}
