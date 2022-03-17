//
//  ViewController.swift
//  imageUpload
//
//  Created by Philip Chau on 9/3/2022.
//

import UIKit
import FirebaseStorage
import PayPalCheckout
import FirebaseDatabase

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let storage = Storage.storage().reference()
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btn: UIButton!
    let urls = ["file.png", "67016660-BE60-4985-ABF8-659378F2D07C.png"]
    let url1 = "https://firebasestorage.googleapis.com:443/v0/b/uploadimage-94ed0.appspot.com/o/images%2F67016660-BE60-4985-ABF8-659378F2D07C.png?alt=media&token=c68212b3-d116-42fb-9b45-c21520daf3eb"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storageRef = Storage.storage().reference()
        for i in 0..<urls.count {
            let ref = storageRef.child("/images/\(urls[i])")
            ref.getData(maxSize: 5*1024*1025, completion: { data, error in
                guard error == nil else{
                    print("failed to get data")
                    return
                }
                DispatchQueue.main.async {
                    let iv = UIImageView()
                    let x = self.view.frame.size.width * CGFloat(i)
                    iv.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                    let image = UIImage(data: data!)
                    iv.image = image
                    self.sv.contentSize.width = self.sv.frame.size.width * CGFloat(i + 1)
                    self.sv.addSubview(iv)
                }
            })
        }
        let ref = storageRef.child("/images/67016660-BE60-4985-ABF8-659378F2D07C.png")
//        let ref = storageRef.child("/images/file.png")
        ref.getData(maxSize: 5*1024*1025, completion: { data, error in
            guard error == nil else{
                print("failed to get data")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.img.image = image
            }
        })
        
        let paymentButton = PayPalButton(label: .checkout)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(paymentButton)
        
        NSLayoutConstraint.activate(
            [
                paymentButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
                paymentButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
                paymentButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
                paymentButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
            ]
        )
        configurePayPalCheckout()
    }
    
    func configurePayPalCheckout() {
        Checkout.setCreateOrderCallback { createOrderAction in
            let amount = PurchaseUnit.Amount(currencyCode: .cad, value: "10.00")
            let purchaseUnit = PurchaseUnit(amount: amount)
            let order = OrderRequest(intent: .capture, purchaseUnits: [purchaseUnit])

            createOrderAction.create(order: order)
        }

        Checkout.setOnApproveCallback { approval in
             approval.actions.capture { (response, error) in
                print("Order successfully captured: \(response?.data)")
            }
        }

    }

    @IBAction func onPAClick(_ sender: UINavigationItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }

        //all file will be uploaded as png
        let uuid = UUID()
        storage.child("/images/\(uuid).png").putData(imageData, metadata: nil, completion: {_, error in
            guard error == nil else {
                print("failed to upload data")
                return
            }
            self.storage.child("/images/\(uuid).png").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                var urlString = url.absoluteString
                let dbRef = Database.database().reference(withPath: "user1")
                dbRef.child("user1").setValue(urlString)
                dbRef.observe(.value) { (snapshot) in
                    if let output = snapshot.value {
                        print(output)
                        let user1 = (output as? [String:AnyObject])!
                        
                        print("url of user1 is \(user1["user1"])")
                    }
                }
                print("download url: \(urlString)")
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

