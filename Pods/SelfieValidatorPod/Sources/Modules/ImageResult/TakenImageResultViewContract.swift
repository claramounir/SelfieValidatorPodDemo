//
//  SelfieValidatorViewController.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 06/07/2023.
//

import Foundation

// MARK: - Router
protocol TakenImageResultWireFrameProtocol: AnyObject {
    func go(to route: TakenImageResultWireFrame.Route)
}

// MARK: - ViewModel Input
protocol TakenImageResultViewModelInput: AnyObject {
    func viewDidLoad()
    func recaptureButtonWasTapped()
    func approveButtonWasTapped()
}

// MARK: - ViewModel Output
protocol TakenImageResultViewModelOutput: AnyObject {
    func setupUI(image: UIImage)
}

// MARK: - Result Delegate
public protocol ImageCapturedDelegate: AnyObject {
    func didCapturedImage(_image : UIImage)
}
