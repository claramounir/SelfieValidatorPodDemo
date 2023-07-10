//
//  SelfieValidatorViewController.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 06/07/2023.
//

import UIKit

class SelfieValidatorViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var capturePreviewView: UIView!
    
    // MARK: Properties
    
    public var delegate: ImageCapturedDelegate?
    private let viewModel: SelfieValidatorViewModelInput

    // MARK: Init

    init(viewModel: SelfieValidatorViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: SelfieValidatorViewController.identifier , bundle: Bundle.selfieValidatorBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad(with: self.capturePreviewView)
    }
    
    // MARK: deInit
    deinit {
        debugPrint("deinitialized \(SelfieValidatorViewController.self)")
    }
    
}

// MARK: SelfieValidatorViewModelOutput

extension SelfieValidatorViewController: SelfieValidatorViewModelOutput {
    func showToast(msg: String) {
        self.showToastMessage(msg)
    }
    
    func setUpUI() {
        styleCaptureButton()
    }
}

// MARK: - Actions

extension SelfieValidatorViewController {
    @IBAction func captureButton(_ sender: Any) {
        viewModel.didCaptureImage()
    }
}

// MARK: - Configurations

extension SelfieValidatorViewController {
    func styleCaptureButton() {
        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.borderWidth = 2
        captureButton.backgroundColor = .white.withAlphaComponent(0.5)
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
    }
}
