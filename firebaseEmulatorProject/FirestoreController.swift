//
//  FirestoreController.swift
//  firebaseEmulatorProject
//
//  Created by Akiya Ozawa on R 3/08/13.
//

import UIKit
import Firebase
import FirebaseFirestore

class FirestoreController: UIViewController {
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "John"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let ageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "32"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Store to Firestore", for: .normal)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    @objc fileprivate func handleSubmit() {
        saveDataToFirestore()
    }
    
    private func saveDataToFirestore() {
                
        guard let username = usernameTextField.text else {return}
        guard let age = ageTextField.text else {return}
        
        let data = ["username": username, "age": age]
        
        let firestore = Firestore.firestore()
        firestore.settings = Configuration.shared.FirestoreSettings()
        firestore.collection("users").addDocument(data: data) { error in
            if let error = error {
                print("error", error.localizedDescription)
                return
            }
            
            print("Successfully stored data into Firestore")
            
        }

    }
    
    private func saveToDatatoRealtimeDatabase() {
        
        let db = Database.database(url: "http://localhost:9000?ns=YOUR_DATABASE_NAMESPACE")

    }
    
    private func setupView() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        view.addSubview(ageTextField)
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        ageTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 15).isActive = true
        ageTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        ageTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 30).isActive = true
        submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        submitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        
    }
}
