//
//  SettingsController.swift
//  Tinder_Clone
//
//  Created by Igor Tkach on 1/14/19.
//  Copyright © 2019 Igor Tkach. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}


class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsController: UITableViewController {

    static let defaultMinSeekingAge = 25
    static let defaultMaxSeekingAge = 50
    
    var user: User?
    var delegate: SettingsControllerDelegate?
    
    
    
    lazy var header: UIView = {
        
        let padding: CGFloat = 16
        let header = UIView()
        
        
        header.addSubview(image1Button)
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    //instance properties
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    
    
    let buttonBarWidth = 44
    let buttonBarHeight = 44
    
    
    var backButton: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    var doneSaveButton: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "checked")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }
    
    var logoutButton: UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "logout")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        setupNavigationItem()
        fetchCurrestUser()
    }
    
    
    
    fileprivate func fetchCurrestUser() {
       //fetch FireStore Data
        Firestore.firestore().fetchCurrentUser { (user, error) in
            if let error = error {
                print("Failed to fetch user: ", error)
                return
            }
            self.user = user
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
        }
    
    fileprivate func loadUserPhotos() {
        //call into the cach benefit load directly fron cach when already set in
        if let imageUrl1 = user?.imageUrl1, let url = URL(string: imageUrl1) {
            loadImage(at: url, in: image1Button)
        }
        
        if let imageUrl1 = user?.imageUrl2, let url = URL(string: imageUrl1) {
            loadImage(at: url, in: image2Button)
        }
        
        if let imageUrl1 = user?.imageUrl3, let url = URL(string: imageUrl1) {
            loadImage(at: url, in: image3Button)
        }
        
        

    }
    
    func loadImage(at url: URL, in button: UIButton) {
        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    
    
    //MARK: - Navigation
    fileprivate func setupNavigationItem() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        //Left bar
        let backBarItem = UIBarButtonItem(customView: backButton)
        backBarItem.customView?.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: CGSize(width: buttonBarWidth, height: buttonBarHeight))
        navigationItem.leftBarButtonItem = backBarItem
        //right bar
        
        
        let saveBarItem = UIBarButtonItem(customView: doneSaveButton)
        let logoutBarItem = UIBarButtonItem(customView: logoutButton)
        saveBarItem.customView?.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: CGSize(width: buttonBarWidth, height: buttonBarHeight))
        logoutBarItem.customView?.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: CGSize(width: buttonBarWidth, height: buttonBarHeight))
        navigationItem.rightBarButtonItems = [saveBarItem, logoutBarItem]
    }
    
    
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error can't logout")
        }
        dismiss(animated: true)
    }
    
    
    @objc fileprivate func handleSave() {
        let hud = JGProgressHUD(style: .dark)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String : Any] = [
            "uuid" : uid,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "age": user?.age ?? 18,
            "profession": user?.profession ?? "N\\A",
            "minSeekingAge": user?.minSeekingAge ?? 18,
            "maxSeekingAge": user?.maxSeekingAge ?? 35
        ]
        
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let error = error {
                print("Failed to save user settings", error)
                return
            }
            hud.dismiss()
            self.dismiss(animated: true, completion: {
                self.delegate?.didSaveSettings()
            })
        }
    }
    
    
    
}

//Add padding for left side of header
class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}



//MARK: - TableView

extension SettingsController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
            let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
            
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
            return headerLabel
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        } else {
            return 44
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(describing: age)
            }
        case 4:
            cell.textField.placeholder = "Enter Bio"
        default:
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil) // age range cell
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            // we need to set up the labels on our cell here
            let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
            let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
            
            ageRangeCell.minLabel.text = "Min: \(minAge)"
            ageRangeCell.maxLabel.text = "Max: \(maxAge)"
            smileDetect(sliderValue: minAge, slider: ageRangeCell.minSlider)
            smileDetect(sliderValue: maxAge, slider: ageRangeCell.maxSlider)
            return ageRangeCell
        }
        
        return cell
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        //update maxLabel in my AgeRangeCell
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        evaluateMinMax()
        ageRangeCell.maxLabel.text = "Max: \(Int(slider.value))"
        self.user?.maxSeekingAge = Int(slider.value)
        smileDetect(sliderValue: Int(slider.value), slider: slider)
    }
    
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        //update minLabel in my AgeRangeCell
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        evaluateMinMax()
        ageRangeCell.minLabel.text = "Min: \(Int(slider.value))"
        self.user?.minSeekingAge = Int(slider.value)
        smileDetect(sliderValue: Int(slider.value), slider: slider)
        
    }
    
    fileprivate func evaluateMinMax() {
        guard let ageRangeCell = tableView.cellForRow(at: [5, 0]) as? AgeRangeCell else { return }
        let minSliderValue = Int(ageRangeCell.minSlider.value)
        let maxSliderValue = Int(ageRangeCell.maxSlider.value)
        let minValue = min(minSliderValue, maxSliderValue)
        let maxValue = max(minSliderValue, maxSliderValue)
        ageRangeCell.maxSlider.value = Float(maxValue)
        ageRangeCell.minSlider.value = Float(minValue)
        ageRangeCell.minLabel.text = "Min: \(minValue)"
        ageRangeCell.maxLabel.text = "Max: \(maxValue)"
        user?.minSeekingAge = minValue
        user?.maxSeekingAge = maxValue
    }
    
    fileprivate func smileDetect(sliderValue: Int, slider: UISlider) {
        switch sliderValue {
        case 18...26 :
            slider.setThumbImage(UIImage(named: "happy2"), for: .normal)
        case 26...45 :
            slider.setThumbImage(UIImage(named: "happy"), for: .normal)
        case 45...70 :
            slider.setThumbImage(UIImage(named: "unhappy"), for: .normal)
        case 70...80:
            slider.setThumbImage(UIImage(named: "crying"), for: .normal)
        default :
            return
        }
        slider.value = Float(sliderValue)
    }
    
    
    
    
    
   
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
       self.user?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    
    
    
}




//MARK: - ImagePicker Controller

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text  = "Uploading image..."
        hud.show(in: view)
        reference.putData(uploadData, metadata: nil) {  (nil, error) in
            
            if let error = error {
                print("Failed to upload image to storage: ", error)
                return
            }
            
            hud.dismiss()
            print("Finished uploading image")
            reference.downloadURL(completion: { [unowned self] (url, err) in
                if let err = err {
                    print("Failed to retrieve download URL", err)
                }
                print("Finished getting download url: ", url?.absoluteString ?? "")
                
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            })
        }
    }
    
    
    
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
}
