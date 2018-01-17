import Foundation
import os.log

class MealApi {
    // MARK: - Properties
    private var archiveURL: URL

    init() {
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = documentsDirectory.appendingPathComponent("meals")
    }

    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: self.archiveURL.path) as? [Meal]
    }

    func saveMeals(meals: [Meal]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: archiveURL.path)

        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
}
