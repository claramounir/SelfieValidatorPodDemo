//
//  SelfieValidatorViewController.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 06/07/2023.
//

import Foundation

// MARK: TakenImageResultViewModel

class TakenImageResultViewModel {
    
    weak var controllerDelegate: TakenImageResultViewModelOutput?
    var wireFrame: TakenImageResultWireFrameProtocol?
    var selfieimage: UIImage
    
    init(selfieimage: UIImage) {
        self.selfieimage = selfieimage
    }
}

// MARK: TakenImageResultViewModel

extension TakenImageResultViewModel: TakenImageResultViewModelInput {
    func recaptureButtonWasTapped() {
        wireFrame?.go(to: .reCapture)
    }
    
    func approveButtonWasTapped() {
        wireFrame?.go(to: .approve)
    }
    
    func viewDidLoad() {
        controllerDelegate?.setupUI(image: selfieimage)
    }
    
}
