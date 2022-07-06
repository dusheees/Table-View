//
//  AddEditTableViewController.swift
//  Table View
//
//  Created by Андрей on 06.07.2022.
//

import UIKit

class AddEditTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet var tankImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var switchesCollection: [UISwitch]!
    @IBOutlet var barButtonItem: UIBarButtonItem!
    
    // MARK: - Properties
    var tank = Tank()

    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(cameraImagePressed))
        tankImageView.addGestureRecognizer(tap)
        tankImageView.isUserInteractionEnabled = true
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        descriptionTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        updateUI()
        inputCheck()
        
        if tankImageView.image == nil {
            tankImageView.addText("Выберите фото танка")
        }
    }
    
    // MARK: - Methods
    func updateUI() {
        tankImageView.image = UIImage(data: tank.tankImage)
        nameTextField.text = tank.name
        descriptionTextField.text = tank.description
        
        for (index, switchElement) in switchesCollection.enumerated() {
            switchElement.tag = index
        }
        
        switchIsOn(index: tank.type?.rawValue ?? -1)
    }
    
    func saveTank() {
        tank.tankImage = tankImageView.image?.pngData() ?? UIImage().pngData()!
        tank.name = nameTextField.text ?? ""
        tank.description = descriptionTextField.text ?? ""
        for switchElement in switchesCollection {
            if switchElement.isOn {
                switch switchElement.tag {
                case 0:
                    tank.type = .light
                case 1:
                    tank.type = .medium
                case 2:
                    tank.type = .heavy
                case 3:
                    tank.type = .destroyer
                default:
                    print("Error")
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveSegue" else { return }
        saveTank()
    }
    
    // MARK: - Actions
    @IBAction func switchAction(_ sender: UISwitch) {
        for switchElement in switchesCollection {
            if sender != switchElement {
                switchElement.isOn = false
            }
        }
        inputCheck()
    }
    
    // MARK: - Targets
    @objc func cameraImagePressed(_ sender: UIImageView) {
        tankImageView.removeAll()
        
        let alert = UIAlertController(title: "Please Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            if self.tankImageView.image == nil {
                self.tankImageView.addText("Выберите фото танка")
            }
        }
        alert.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
            alert.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Library", style: .default) { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
            alert.addAction(photoLibraryAction)
        }
        
        alert.popoverPresentationController?.sourceView = sender
        
        present(alert, animated: true)
        
        inputCheck()
    }
    
    @objc func textFieldDidChange() {
        inputCheck()
    }
    
}

// MARK: - switch is on
extension AddEditTableViewController {
    func switchIsOn(index: Int) {
        for switchElement in switchesCollection {
            if switchElement.tag == index {
                switchElement.isOn = true
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddEditTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        tankImageView.image = selectedImage
        dismiss(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension AddEditTableViewController: UINavigationControllerDelegate {}

// MARK: - input check
extension AddEditTableViewController {
    func inputCheck() {
        var flag: Bool = false
        for switchElement in switchesCollection {
            if switchElement.isOn {
                flag = true
                break
            } else {
                flag = false
            }
        }
        
        if  flag == true && tankImageView.image != nil && nameTextField.text != "" && descriptionTextField.text != "" {
            barButtonItem.isEnabled = true
        } else {
            barButtonItem.isEnabled = false
        }
    }
}

// MARK: - UIImageView Text
extension UIImageView {
    func addText(_ text: String) {
        let lblText = UILabel(frame: self.bounds)
        lblText.text = text
        lblText.textAlignment = .center
        self.addSubview(lblText)
    }

    func removeAll() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
}
