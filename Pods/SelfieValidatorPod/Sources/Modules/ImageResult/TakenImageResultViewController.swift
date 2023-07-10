//
//  SelfieValidatorViewController.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 06/07/2023.
//

import UIKit

class TakenImageResultViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var approveButton: UIButton!
    @IBOutlet private weak var recaptureButton: UIButton!
    
    private let viewModel: TakenImageResultViewModelInput
    
    // MARK: Init

    init(viewModel: TakenImageResultViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: TakenImageResultViewController.identifier , bundle: Bundle.selfieValidatorBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    // MARK: deInit
    deinit {
        debugPrint("deinitialized \(TakenImageResultViewController.self)")
    }
    
}

// MARK: - Actions

extension TakenImageResultViewController {
    
    @IBAction func recaptureButtonWasTapped(_ sender: Any) {
        viewModel.recaptureButtonWasTapped()
    }
    
    @IBAction func approveButtonWasTapped(_ sender: Any) {
        viewModel.approveButtonWasTapped()
    }
}

// MARK: - ViewModel Output

extension TakenImageResultViewController: TakenImageResultViewModelOutput {
    
    func setupUI(image: UIImage) {
        self.imageView.image = image
    }
}
