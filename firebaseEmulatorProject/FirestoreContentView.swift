//
//  FirestoreContentView.swift
//  firebaseEmulatorProject
//
//  Created by Akiya Ozawa on R 3/08/28.
//

import SwiftUI
import Firebase

struct UserInfo: Codable, Identifiable {
    var id = UUID()
    var username: String
    var age: String
    
    init(dictionary: [String: Any]?) {
        self.username = dictionary?["username"] as? String ?? ""
        self.age = dictionary?["age"] as? String ?? ""
    }
}

class FRContentViewModel: ObservableObject {
    
    @Published var userInfo: UserInfo?
    
    func storeUserInfo(username: String, age: String) {
        let data = ["username": username, "age": age]

        let auth = Configuration.shared.auth()
        auth.signInAnonymously { result, error in

            if let error = error {
                print("failed to singn in anonymously", error.localizedDescription)
                return
            }
            
            guard let uid = result?.user.uid else { return }

            let firestore = Firestore.firestore()
            firestore.settings = Configuration.shared.FirestoreSettings()
            firestore.collection("userInfo").document(uid).setData(data, merge: true) { error in

                if let error = error {
                    print("error", error.localizedDescription)
                    return
                }
                print("Successfully stored data into Firestore")
            }
        }
    }
    
    func fetchUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let firestore = Firestore.firestore()
        firestore.settings = Configuration.shared.FirestoreSettings()
        firestore.collection("userInfo").document(uid).getDocument { snapshot, err in
            if let err = err {
                print("faield to fetch fata", err.localizedDescription)
                return
            }
            let userInfo = UserInfo(dictionary: snapshot?.data())
            self.userInfo = userInfo
        }
    }
    
    func deleteUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let firestore = Firestore.firestore()
        firestore.settings = Configuration.shared.FirestoreSettings()
        firestore.collection("userInfo").document(uid).delete { err in
            if let err = err {
                print("failed to delete", err.localizedDescription)
                return
            }
            print("Successfully deleted data in Firestore")
        }
    }
}


import SwiftUI
import Firebase

struct FirestoreContentView: View {

    @State private var username = ""
    @State private var age = ""
    @ObservedObject var viewModel = FRContentViewModel()
    
    var body: some View {
        VStack {
            Text("Firestore Emulator 🔥")
                .font(.title)
                .padding(.bottom)
                .foregroundColor(.blue)
            TextField("Enter username", text: $username)
                .padding(20)
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray))
            TextField("Enter age", text: $age)
                .padding(20)
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray))
            Button(action: {
                viewModel.storeUserInfo(username: username, age: age)
            } ) {
                Text("Save data")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            Button(action: {
                viewModel.fetchUserInfo()
            } ) {
                Text("Fetch data")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .cornerRadius(15)
            }
            Text("UserName: \(viewModel.userInfo?.username ?? "")")
            Text("Age: \(viewModel.userInfo?.age ?? "")")
            Button(action: {
                viewModel.deleteUserInfo()
            } ) {
                Text("Delete data")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.red)
                    .cornerRadius(15)
            }
        }
        .padding(.all)
    }
}

struct FirestoreContentView_Previews: PreviewProvider {
    static var previews: some View {
        FirestoreContentView()
    }
}
