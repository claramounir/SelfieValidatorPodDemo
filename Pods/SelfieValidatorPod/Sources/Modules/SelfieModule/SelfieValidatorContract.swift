//
//  SelfieValidatorContract.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 08/07/2023.
//

import Foundation

// MARK: - Router
protocol SelfieValidatorWireFrameProtocol: AnyObject {
    func go(to route: SelfieValidatorWireFrame.Route)
}

// MARK: - ViewModel Input
protocol SelfieValidatorViewModelInput {
    func viewDidLoad(with preview: UIView)
    func didCaptureImage()
}

// MARK: - ViewModel Output
protocol SelfieValidatorViewModelOutput: AnyObject {
    func setUpUI()
    func showToast(msg : String)
}


