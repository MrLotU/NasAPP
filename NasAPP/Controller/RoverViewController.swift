//
//  RoverViewController.swift
//  NasAPP
//
//  Created by Jari Koopman on 11/10/2017.
//  Copyright © 2017 JarICT. All rights reserved.
//

import UIKit
import MobileCoreServices
import MessageUI


class RoverViewController: NasAPPViewController {

    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var postcardView: UIView!
    @IBOutlet weak var postcardImageView: UIImageView!
    @IBOutlet weak var postcardTextField: UITextField!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var removeTextButton: UIButton!
    @IBOutlet weak var changeTextColorButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Drag and drop
        let dragInteraction = UIDragInteraction(delegate: self)
        postcardTextField.addInteraction(dragInteraction)
        postcardTextField.isUserInteractionEnabled = true
        postcardTextField.delegate = self
        postcardTextField.text = "Greetings from mars!"
        postcardTextField.sizeToFit()
        
        let dropInteraction = UIDropInteraction(delegate: self)
        postcardView.addInteraction(dropInteraction)
        postcardView.clipsToBounds = true

        // MARK: Button setup
        homeButton.addTarget(self, action: #selector(didPressHomeButton), for: .touchUpInside)
        addTextButton.addTarget(self, action: #selector(pressedAddTextButton), for: .touchUpInside)
        removeTextButton.addTarget(self, action: #selector(pressedRemoveTextButton), for: .touchUpInside)
        chooseImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        changeTextColorButton.addTarget(self, action: #selector(changeTextColor), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        postcardImageView.contentMode = .scaleAspectFill
    }
}

// MARK: - Sending
extension RoverViewController: MFMailComposeViewControllerDelegate {
    @objc func send() {
        //Create the image that we're going to send from the view
        let image = UIImage(view: self.postcardView)
        guard let pngImage = UIImagePNGRepresentation(image) else {
            self.showAlert(withTitle: "Image error!", andMessage: "Something went wrong while trying to create the postcard! Try again later!")
            return
        }
        // Create the email
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Mars rover postcard!")
            mail.addAttachmentData(pngImage, mimeType: "image/png", fileName: "postcard")
            
            present(mail, animated: true)
        } else {
            // Show alert if email is not set up correctly
            self.showAlert(withTitle: "Mail error!", andMessage: "Something went wrong while trying to create the email! Make sure your email is set up and try again!")
            print("Can't send mail")
        }
    }
    
    // Dismiss the mail controller once done
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension UIImage {
    /// Creates an image from the contents of a UIView
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

// MARK: - Image Picking
extension RoverViewController: ImagePickerDelegate {
    /// Sets image once one is picked
    func didFinishPickingImage(image: UIImage) {
        self.postcardImageView.image = image
    }
    
    /// Starts image selection process
    @objc func selectImage() {
        self.performSegue(withIdentifier: "pickRoverImage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickRoverImage" {
            let destVC = segue.destination as! SelectRoverImageViewController
            destVC.delegate = self
            destVC.image = self.postcardImageView.image ?? UIImage(named: "Default")
        }
    }
}

// MARK: - Drag and Drop
extension RoverViewController: UIDragInteractionDelegate, UIDropInteractionDelegate {
    /*
     Add drag and drop implementation for the TextField
    */
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let text = postcardTextField.text else { return [] }
        
        let provider = NSItemProvider(object: text as NSItemProviderWriting)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = text

        return [item]
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeText as String]) && session.items.count == 1
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let location = session.location(in: postcardView)
        self.postcardTextField.center = location
    }
}

// MARK: - Text editing
extension RoverViewController: UITextFieldDelegate {
    /*
     Text field functionalities:
     - Change text to `Click to edit` when empty
     - Resize textfield to fit text
     - Change textcolor from black to white and vice versa on button press
     - Show/hide add/remove text on button press
    */
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "Click to edit"
        }
        textField.sizeToFit()
    }
    
    @objc func changeTextColor() {
        if postcardTextField.textColor == .black {
            let text = postcardTextField.text
            postcardTextField.textColor = .white
            postcardTextField.text = text
        } else {
            let text = postcardTextField.text
            postcardTextField.textColor = .black
            postcardTextField.text = text
        }
    }
    
    @objc func pressedAddTextButton() {
        postcardTextField.becomeFirstResponder()
        postcardTextField.text = "Click to edit"
        postcardTextField.selectAll(nil)
    }
    
    @objc func pressedRemoveTextButton() {
        postcardTextField.endEditing(true)
        postcardTextField.text = ""
    }
}
