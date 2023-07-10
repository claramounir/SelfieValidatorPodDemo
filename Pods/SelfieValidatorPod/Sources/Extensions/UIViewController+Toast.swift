//
//  UIViewController+Toast.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 09/07/2023.
//

import Foundation
extension UIViewController {
  
  func showToastMessage(_ message: String, duration: ToastDuration = .long) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let toastLbl = createToastLabel()
        toastLbl.text = message
        
        let textSize = toastLbl.intrinsicContentSize
        let labelHeight = ( textSize.width / window.frame.width ) * 30
        let labelWidth = min(textSize.width, window.frame.width - 40)
        let adjustedHeight = max(labelHeight, textSize.height + 20)
        
        toastLbl.frame = CGRect(x: 20, y: (window.frame.height - 90 ) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
        toastLbl.center.x = window.center.x
        toastLbl.layer.cornerRadius = 10
        toastLbl.layer.masksToBounds = true
        
        window.addSubview(toastLbl)
        
    UIView.animate(withDuration: duration.duration, animations: {
            toastLbl.alpha = 0
        }) { (_) in
            toastLbl.removeFromSuperview()
        }
    }
  
  private func createToastLabel() -> UILabel {
    let toastLbl = UILabel()
    toastLbl.textAlignment = .center
    toastLbl.font = UIFont.systemFont(ofSize: 18)
    toastLbl.textColor = UIColor.white
    toastLbl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLbl.numberOfLines = 0
    return toastLbl
  }
}

// MARK: - Toast + Duration
//
 enum ToastDuration {
  
  case short
  case long
  
  var duration: TimeInterval {
    switch self {
    case .long:
    return 3
    case .short:
    return 1
    }
  }
}
