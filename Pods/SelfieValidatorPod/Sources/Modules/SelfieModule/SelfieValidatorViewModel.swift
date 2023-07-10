//
//  SelfieValidatorViewModel.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 06/07/2023.
//

import Foundation

class SelfieValidatorViewModel {
    
    let cameraController = CameraController()
    weak var controllerDelegate: SelfieValidatorViewModelOutput?
    var wireFrame: SelfieValidatorWireFrameProtocol?
    
    func configureCameraController(for view: UIView) {
        cameraController.prepare {[weak self] (error) in
            if let error = error {
                self?.controllerDelegate?.showToast(msg: error.errorMsg)
            }
            
            try? self?.cameraController.displayPreview(on: view)
        }
    }
}

// MARK: Input Protocol
extension SelfieValidatorViewModel: SelfieValidatorViewModelInput {
    
    func didCaptureImage() {
        cameraController.captureImage(completion:{[weak self](image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            self?.navigateToImageView(image: image)
        })
    }
    
    func viewDidLoad(with preview: UIView) {
        configureCameraController(for: preview)
        controllerDelegate?.setUpUI()
    }
}

// MARK: Naviagtions

private extension SelfieValidatorViewModel {
    
    func navigateToImageView(image: UIImage) {
        wireFrame?.go(to: .imageView(image: image))
    }
}
