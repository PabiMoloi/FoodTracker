import UIKit
import os.log

protocol MealView: class {
}

class MealViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!

    private var saveButton: UIBarButtonItem!

    var meal: MealViewData?
    var mealIndex: Int?
    var mealPresenter: MealPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        mealPresenter.attachView(self)

        nameTextField.delegate = self

        setupNavigationBar()
        setupTapGesture()
        setupMeal()
        updateSaveButtonState()
    }

    // MARK: - Private Methods
    private func setupNavigationBar() {
        navigationItem.title = "New Meal"

        let cancelButton = UIBarButtonItem(
            title: "Cancel", style: .plain, target: self, action: #selector(MealViewController.cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton

        var saveAction: Selector!
        if presentingViewController is UINavigationController {
            saveAction = #selector(MealViewController.saveButtonForAddTapped)
        } else {
            saveAction = #selector(MealViewController.saveButtonForUpdateTapped)
        }
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: saveAction)
        navigationItem.rightBarButtonItem = saveButton
    }

    private func setupTapGesture() {
        tapGesture.addTarget(self, action: #selector(MealViewController.selectImageFromPhotoLibrary))
        photoImageView.addGestureRecognizer(tapGesture)
    }

    private func setupMeal() {
        if let meal = meal {
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
    }

    fileprivate func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

    fileprivate func back() {
        guard presentingViewController is UINavigationController else {
            navigationController?.popViewController(animated: true)
            return
        }

        dismiss(animated: true, completion: nil)
    }
}

// MARK: - MealView
extension MealViewController: MealView {}

// MARK: - Actions
extension MealViewController {
    @IBAction func selectImageFromPhotoLibrary() {
        print("aaa")
        nameTextField.resignFirstResponder()

        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self

        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func cancelButtonTapped() {
        back()
    }

    @IBAction func saveButtonForAddTapped() {
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating

        self.mealPresenter.addMeal(name: name, photo: photo, rating: rating)

        back()
    }

    @IBAction func saveButtonForUpdateTapped() {
        guard let index = mealIndex else { back(); return }

        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating

        self.mealPresenter.updateMeal(at: index, name: name, photo: photo, rating: rating)

        back()
    }
}

// MARK: - UITextFieldDelegate
extension MealViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MealViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage

        dismiss(animated: true, completion: nil)
    }
}
