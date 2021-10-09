//
//  ViewController.swift
//  regognizeTextTest
//
//  Created by minmin on 2021/07/21.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setupVisionTextRecognizeImage(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest(completionHandler: { request, error in
            guard let  observations = request.results as? [VNRecognizedTextObservation] else {fatalError("失敗") }
            let text = observations.compactMap( { $0.topCandidates(1).first?.string }).joined(separator: ",")
            DispatchQueue.main.async {
                self.textView.text = text
            }
        }
        )
        request.recognitionLevel = .accurate
        
        let requests = [request]
        
        do {
            try handler.perform(requests)
        } catch {
            print(error)
        }


    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        setUpGallery()
    }

    private func setUpGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker,animated: true,completion: nil)
    }
    
    private func startAnimating () {
    }
    
    
}


extension ViewController :UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageView.image = image
        setupVisionTextRecognizeImage(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
}
