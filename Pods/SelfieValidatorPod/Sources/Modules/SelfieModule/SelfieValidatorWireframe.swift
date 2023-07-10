//
//  SelfieValidatorWireframe.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 08/07/2023.
//

import Foundation

public class SelfieValidatorWireFrame: SelfieValidatorWireFrameProtocol {
    
    // MARK: - Routes
    
    enum Route {
        case imageView(image: UIImage)
    }
    
    // MARK: - Attributes
    
    private weak var viewController: UIViewController?
    private weak var moduleDlegate: ImageCapturedDelegate?
    
    // MARK: - LifeCycle
    
    public init() {}
    
    deinit {
        debugPrint("deinit SelfieValidatorWireFrame")
    }
    
    // MARK: - Methods
    
    public func assembleModule(moduleDlegate: ImageCapturedDelegate) -> UIViewController {
        let viewModel = SelfieValidatorViewModel()
        let view = SelfieValidatorViewController(viewModel: viewModel)
        let wireFrame = SelfieValidatorWireFrame()
        wireFrame.moduleDlegate = moduleDlegate
        viewModel.controllerDelegate = view
        viewModel.wireFrame = wireFrame
        wireFrame.viewController = view
        return view
    }
    
}

// MARK: - Navigation

extension SelfieValidatorWireFrame {
    func go(to route: Route) {
        switch route {
        case .imageView(let image):
            navigateToImagePreview(image: image)
        }
    }
    
    private func navigateToImagePreview(image: UIImage) {
        let wireframe = TakenImageResultWireFrame()
        let imageViewController = wireframe.assembleModule(image: image, moduleDlegate: self.moduleDlegate)
        self.viewController?.navigationController?.pushViewController(imageViewController, animated: true)
    }
}
