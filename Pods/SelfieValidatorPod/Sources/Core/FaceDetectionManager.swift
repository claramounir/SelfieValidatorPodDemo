//
//  FaceDetectionManager.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 08/07/2023.
//

import Foundation
import Vision
import AVFoundation

class FaceDetectionManager {
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var drawings = [CAShapeLayer]()
    private var displayView: UIView?
    
    public func setPreviewLayer(previewLayer: AVCaptureVideoPreviewLayer?, displayView: UIView?) {
        self.previewLayer = previewLayer
        self.displayView = displayView
    }
    
    public func detectFace(in image: CVPixelBuffer, sampleBuffer: CMSampleBuffer) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation] {
                    self.handleFaceDetectionResults(results)
                } else {
                    self.clearDrawings()
                }
            }
        })
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
    
    private func handleFaceDetectionResults(_ observedFaces: [VNFaceObservation]) {
        
        self.clearDrawings()
        let facesBoundingBoxes: [CAShapeLayer] = observedFaces.flatMap({ (observedFace: VNFaceObservation) -> [CAShapeLayer] in
            let faceBoundingBoxOnScreen = self.previewLayer?.layerRectConverted(fromMetadataOutputRect: observedFace.boundingBox)
            let faceBoundingBoxPath = CGPath(rect: faceBoundingBoxOnScreen ?? CGRect(), transform: nil)
            let faceBoundingBoxShape = CAShapeLayer()
            faceBoundingBoxShape.path = faceBoundingBoxPath
            faceBoundingBoxShape.fillColor = UIColor.clear.cgColor
            faceBoundingBoxShape.strokeColor = UIColor.blue.cgColor
            var newDrawings: [CAShapeLayer] = []
            newDrawings.append(faceBoundingBoxShape)
            if let _ = observedFace.landmarks {
                newDrawings = newDrawings
            }
            return newDrawings
        })
        guard let displayView = displayView else { return }
        facesBoundingBoxes.forEach({ faceBoundingBox in displayView.layer.addSublayer(faceBoundingBox) })
        self.drawings = facesBoundingBoxes
    }
    
    private func clearDrawings() {
        self.drawings.forEach({ drawing in drawing.removeFromSuperlayer() })
    }
    
    public func validateFaces(sampleBuffer: CMSampleBuffer?) -> CameraController.CameraControllerError?{
        guard let sampleBuffer = sampleBuffer else {
            return .unknown
        }
        // Try and get a CVImageBuffer out of the sample buffer
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return .unknown
        }
        
        // Get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
        let faces = faceDetector.features(in: ciImage)
        
        guard faces.first != nil  else {
            debugPrint("No Face Found")
            return .noFaceFound
        }
        
        guard faces.count == 1 else {
            debugPrint("A lot of faces are detected..! \n We need only one face")
            return .tooManyFaces
        }
        return nil
    }
}
