//
//  docufeedApp.swift
//  docufeed
//
//  Created by Umar Ahmed on 6/10/24.
//

import SwiftUI
import UIKit
import Vision

@main
struct docufeedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController loaded") // Debugging line
        
        // Set up the image view to display the captured image
        imageView = UIImageView(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
        // Set up the capture button
        let captureButton = UIButton(type: .system)
        captureButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        captureButton.setTitle("Capture Document", for: .normal)
        captureButton.setTitleColor(.blue, for: .normal)
        captureButton.addTarget(self, action: #selector(captureDocument), for: .touchUpInside)
        self.view.addSubview(captureButton)
        
        print("Capture button added to view") // Debugging line
    }
    
    @objc func captureDocument() {
        print("Capture Document button tapped") // Debugging line
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Camera not available") // Debugging line
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image picked") // Debugging line
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            performOCROnImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func performOCROnImage(image: UIImage) {
        print("Performing OCR") // Debugging line
        guard let cgImage = image.cgImage else {
            print("Failed to get CGImage from UIImage") // Debugging line
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error.localizedDescription)") // Debugging line
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("No text recognized") // Debugging line
                return
            }
            
            var extractedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                extractedText += topCandidate.string + "\n"
            }
            
            // Process extracted text to identify specific values
            self.processExtractedText(extractedText)
        }
        request.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error performing OCR: \(error.localizedDescription)") // Debugging line
        }
    }
    
    func processExtractedText(_ text: String) {
        print("Processing extracted text") // Debugging line
        print("Extracted Text: \(text)")
        
        // Example: Simple key-value extraction
        let lines = text.split(separator: "\n")
        var keyValuePairs: [String: String] = [:]
        
        for line in lines {
            let parts = line.split(separator: ":")
            if parts.count == 2 {
                let key = parts[0].trimmingCharacters(in: .whitespaces)
                let value = parts[1].trimmingCharacters(in: .whitespaces)
                keyValuePairs[key] = value
            }
        }
        
        // Convert key-value pairs to CSV format
        var csvText = "Key, Value\n"
        for (key, value) in keyValuePairs {
            csvText += "\(key), \(value)\n"
        }
        
        // Save the CSV text to a file
        saveTextToCSV(text: csvText)
    }
    
    func saveTextToCSV(text: String) {
        print("Saving text to CSV") // Debugging line
        let filename = getDocumentsDirectory().appendingPathComponent("extracted_values.csv")
        
        do {
            try text.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            print("CSV file saved at: \(filename.path)")
        } catch {
            print("Failed to save CSV: \(error.localizedDescription)") // Debugging line
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}



/*
@main
struct docufeedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController loaded") // Debugging line
        
        // Set up the image view to display the captured image
        imageView = UIImageView(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
        // Set up the capture button
        let captureButton = UIButton(type: .system)
        captureButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        captureButton.setTitle("Capture Document", for: .normal)
        captureButton.setTitleColor(.blue, for: .normal)
        captureButton.addTarget(self, action: #selector(captureDocument), for: .touchUpInside)
        self.view.addSubview(captureButton)
        
        print("Capture button added to view") // Debugging line
    }
    
    @objc func captureDocument() {
        print("Capture Document button tapped") // Debugging line
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Camera not available") // Debugging line
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image picked") // Debugging line
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            performOCROnImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func performOCROnImage(image: UIImage) {
        print("Performing OCR") // Debugging line
        guard let cgImage = image.cgImage else {
            print("Failed to get CGImage from UIImage") // Debugging line
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error.localizedDescription)") // Debugging line
                return
            }
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("No text recognized") // Debugging line
                return
            }
            
            var extractedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                extractedText += topCandidate.string + "\n"
            }
            
            // Process extracted text to identify specific values
            self.processExtractedText(extractedText)
        }
        request.recognitionLevel = .accurate
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error performing OCR: \(error.localizedDescription)") // Debugging line
        }
    }
    
    func processExtractedText(_ text: String) {
        print("Processing extracted text") // Debugging line
        print("Extracted Text: \(text)")
        
        // Example: Simple key-value extraction
        let lines = text.split(separator: "\n")
        var keyValuePairs: [String: String] = [:]
        
        for line in lines {
            let parts = line.split(separator: ":")
            if parts.count == 2 {
                let key = parts[0].trimmingCharacters(in: .whitespaces)
                let value = parts[1].trimmingCharacters(in: .whitespaces)
                keyValuePairs[key] = value
            }
        }
        
        // Convert key-value pairs to CSV format
        var csvText = "Key, Value\n"
        for (key, value) in keyValuePairs {
            csvText += "\(key), \(value)\n"
        }
        
        // Save the CSV text to a file
        saveTextToCSV(text: csvText)
    }
    
    func saveTextToCSV(text: String) {
        print("Saving text to CSV") // Debugging line
        let filename = getDocumentsDirectory().appendingPathComponent("extracted_values.csv")
        
        do {
            try text.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            print("CSV file saved at: \(filename.path)")
        } catch {
            print("Failed to save CSV: \(error.localizedDescription)") // Debugging line
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

*/
