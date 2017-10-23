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

protocol ImagePickerDelegate {
    func didFinishPickingImage(image: UIImage)
}

class RoverViewController: NasAPPViewController {

    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var postcardView: UIView!
    @IBOutlet weak var postcardImageView: UIImageView!
    @IBOutlet weak var postcardTextField: UITextField!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var removeTextButton: UIButton!
    @IBOutlet weak var randomImageButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragInteraction = UIDragInteraction(delegate: self)
        postcardTextField.addInteraction(dragInteraction)
        postcardTextField.isUserInteractionEnabled = true
        postcardTextField.delegate = self
        
        let dropInteraction = UIDropInteraction(delegate: self)
        postcardView.addInteraction(dropInteraction)
        postcardView.clipsToBounds = true

        homeButton.addTarget(self, action: #selector(didPressHomeButton), for: .touchUpInside)
        addTextButton.addTarget(self, action: #selector(pressedAddTextButton), for: .touchUpInside)
        removeTextButton.addTarget(self, action: #selector(pressedRemoveTextButton), for: .touchUpInside)
        chooseImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        
        postcardImageView.contentMode = .scaleAspectFill
    }
}

// MARK: - Sending
extension RoverViewController: MFMailComposeViewControllerDelegate {
    @objc func send() {
        let image = UIImage(view: self.postcardView)
        guard let pngImage = UIImagePNGRepresentation(image) else {
            //TODO: Handle error
            return
        }
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Mars rover postcard!")
            mail.addAttachmentData(pngImage, mimeType: "image/png", fileName: "postcard")
            
            present(mail, animated: true)
        } else {
            //TODO: Show failure alert
            print("Can't send mail")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension UIImage {
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
    func didFinishPickingImage(image: UIImage) {
        self.postcardImageView.image = image
    }
    
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "Click to edit"
        }
        textField.sizeToFit()
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
