//
//  CameraController.swift
//  SelfieValidatorPod
//
//  Created by Clara Mounir Adly on 05/07/2023.
//


import AVFoundation
import UIKit
import Vision

 class CameraController: NSObject {
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    private var videoOutput : AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    var session : AVCaptureDevice?
    var detectionManager = FaceDetectionManager()
    var sampleBuffer: CMSampleBuffer?
}

 extension CameraController {
    func prepare(completionHandler: @escaping (CameraControllerError?) -> Void) {
        DispatchQueue(label: "prepare").async {
            do {
                self.createCaptureSession()
                try self.configureCaptureDevices()
                try self.configureDeviceInputs()
                try self.configurePhotoOutput()
                self.setupOutput()
            }catch {
                
                DispatchQueue.main.async {
                    completionHandler(error as! CameraController.CameraControllerError)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func createCaptureSession() {
        self.captureSession = AVCaptureSession()
    }
    
    func configureCaptureDevices() throws {
        
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        let cameras = (session.devices.compactMap { $0 })
        guard !cameras.isEmpty else { throw CameraControllerError.noCamerasAvailable }
        
        for camera in cameras {
            if camera.position == .front {
                self.frontCamera = camera
            }
        }
    }
    
    func configureDeviceInputs() throws {
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        if let frontCamera = self.frontCamera {
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
            else { throw CameraControllerError.inputsAreInvalid }
            
        }else { throw CameraControllerError.noCamerasAvailable }
    }
    
    func configurePhotoOutput() throws {
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        self.photoOutput = AVCapturePhotoOutput()
        self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
        
        if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
        captureSession.startRunning()
    }
    
    func setupOutput(){
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if (captureSession?.canAddOutput(videoOutput) ?? false) {
            captureSession?.addOutput(videoOutput)
        } else {
            debugPrint("could not add video output")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
        captureSession?.startRunning()
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        detectionManager.setPreviewLayer(previewLayer: self.previewLayer, displayView: view)
        self.previewLayer?.frame = view.frame
    }
    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        if let error = detectionManager.validateFaces(sampleBuffer: self.sampleBuffer){
            completion(nil, error)
            return 
        }

        let settings = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                            didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                            previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                            resolvedSettings: AVCaptureResolvedPhotoSettings,
                            bracketSettings: AVCaptureBracketedStillImageSettings?,
                            error: Swift.Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
        
        else if let buffer = photoSampleBuffer,
                let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
                let image = UIImage(data: data) {
            self.photoCaptureCompletionBlock?(image, nil)
        }else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
}

extension CameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
        case tooManyFaces
        case noFaceFound
    }
}
extension CameraController.CameraControllerError {
    var errorMsg : String {
        switch self{
            
        case .captureSessionAlreadyRunning:
            return "somthing went wrong"
        case .captureSessionIsMissing:
            return "somthing went wrong"
        case .inputsAreInvalid:
            return "somthing went wrong"
        case .invalidOperation:
            return "somthing went wrong"
        case .noCamerasAvailable:
            return "No Camera Detected"
        case .unknown:
            return "somthing went wrong"
        case .tooManyFaces:
            return "Not Valied Too Many Faces"
        case .noFaceFound:
            return "No Face Found"
        }

    }
    
}
extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        detectionManager.detectFace(in: frame, sampleBuffer: sampleBuffer)
        self.sampleBuffer = sampleBuffer
    }
}
