import UIKit
import os.log

protocol MealTableView: class {
    func reloadMeals()
    func addMeal()
    func deleteMeal(indexPath: IndexPath)
}

class MealTableViewController: UITableViewController {
    //MARK: - Properties
    var mealTablePresenter: MealTablePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealTablePresenter.attachView(self)
        
        setupNavigationBar()
        setupMealTableView()
        mealTablePresenter.loadMeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mealTablePresenter.loadMeals()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Your Meals"
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MealTableViewController.addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupMealTableView() {
        let nib = UINib(nibName: "MealListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MealListCell")
    }
}

//MARK: - Actions
extension MealTableViewController {
    @IBAction func addButtonTapped() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("could not cast to AppDelegate")
        }
        
        let container = appDelegate.container
        let vc = container.resolve(MealView.self) as! MealViewController
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
}

//MARK: - MealTableView
extension MealTableViewController: MealTableView {
    func reloadMeals() {
        self.tableView.reloadData()
    }
    
    func addMeal() {
        let newIndexPath = IndexPath(row: self.mealTablePresenter.numMeals, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
    }
    
    func deleteMeal(indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

//MARK: - UITableViewDataSource
extension MealTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mealTablePresenter.numMeals
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.mealTablePresenter.deleteMeal(indexPath: indexPath)
        } else if editingStyle == .insert {
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealListCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let meal = self.mealTablePresenter.getMeal(at: indexPath.row)
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MealTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = mealTablePresenter.getMeal(at: indexPath.row)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("could not cast to AppDelegate")
        }
        let container = appDelegate.container
        let vc = container.resolve(MealView.self) as! MealViewController
        vc.meal = meal
        vc.mealIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}
