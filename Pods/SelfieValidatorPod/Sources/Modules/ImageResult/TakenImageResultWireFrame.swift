//
//  TakenImageResultWireFrame.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 09/07/2023.
//

import Foundation

class TakenImageResultWireFrame: TakenImageResultWireFrameProtocol {
    
    // MARK: - Routes
    
    enum Route {
        case reCapture
        case approve
    }
    
    // MARK: - Attributes
    
    private weak var viewController: UIViewController?
    private var capturedImage: UIImage?
    weak var moduleDlegate: ImageCapturedDelegate?
    
    // MARK: - LifeCycle
    
    deinit {
        debugPrint("deinit SelfieValidatorWireFrame")
    }
    
    // MARK: - Methods
    
    func assembleModule(image: UIImage, moduleDlegate: ImageCapturedDelegate?) -> UIViewController {
        let viewModel = TakenImageResultViewModel(selfieimage: image)
        let view = TakenImageResultViewController(viewModel: viewModel)
        let wireFrame = TakenImageResultWireFrame()
        wireFrame.moduleDlegate = moduleDlegate
        wireFrame.capturedImage = image
        viewModel.controllerDelegate = view
        viewModel.wireFrame = wireFrame
        wireFrame.viewController = view
        return view
    }
    
}

// MARK: - Navigation

extension TakenImageResultWireFrame {
    func go(to route: Route) {
        switch route {
        case .reCapture:
            self.navigateToReCapture()
        case .approve:
            self.navigateWithApprovedImage()
        }
    }
    
    private func navigateToReCapture() {
        viewController?.navigationController!.popViewController(animated: true)
    }
    
    private func navigateWithApprovedImage() {
        guard let selfieImage = capturedImage else { return }
        moduleDlegate?.didCapturedImage(_image: selfieImage)
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
