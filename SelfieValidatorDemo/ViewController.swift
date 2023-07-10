//
//  ViewController.swift
//  SelfieValidatorDemo
//
//  Created by Clara Mounir Adly on 09/07/2023.
//

import UIKit
import SelfieValidatorPod
class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func startButton(_ sender: UIButton) {
        startButton.layer.cornerRadius = 8.0
        startButton.layer.masksToBounds = true
        let wireFrame = SelfieValidatorWireFrame()
        let view = wireFrame.assembleModule(moduleDlegate: self)
        self.navigationController!.pushViewController(view, animated: true)
    }
}

extension ViewController: ImageCapturedDelegate {
    func didCapturedImage(_image: UIImage) {
        imageView.image = _image
    }

}

