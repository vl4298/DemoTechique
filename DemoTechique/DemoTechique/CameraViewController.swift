//
//  CameraViewController.swift
//  DemoTechique
//
//  Created by Dinh Luu on 29/06/2016.
//  Copyright © 2016 Dinh Luu. All rights reserved.
//

// only test on device, simulator can not use camera front or back

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

  var session: AVCaptureSession! = nil
  var input: AVCaptureDeviceInput! = nil
  var output: AVCaptureStillImageOutput! = nil
  var preview: AVCaptureVideoPreviewLayer! = nil
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    //view.backgroundColor = UIColor.greenColor()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.capturePhoto(_:)))
    view.addGestureRecognizer(tap)
    setupSession()
  }
  
  func capturePhoto(tap: UITapGestureRecognizer) {
    guard let connection = output.connectionWithMediaType(AVMediaTypeVideo) else { return }
    connection.videoOrientation = .Portrait
    
    output.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (sampleBuffer, error) in
      guard sampleBuffer != nil && error == nil else { return }
      
      let imagedata = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
      guard let image = UIImage(data: imagedata) else { return }
      
      // present activity controller
    })
  }
  
  func setupSession() {
    session = AVCaptureSession()
    session.sessionPreset = AVCaptureSessionPresetPhoto
    
    let camera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    do {
      try input = AVCaptureDeviceInput(device: camera)
    } catch { return }
    
    output = AVCaptureStillImageOutput()
    output.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
    
    guard session.canAddInput(input) && session.canAddOutput(output) else { return }
    
    session.addInput(input)
    session.addOutput(output)
    
    preview = AVCaptureVideoPreviewLayer(session: session)
    preview.videoGravity = AVLayerVideoGravityResizeAspect
    preview.frame = view.bounds
    preview.connection.videoOrientation = .Portrait
    
    view.layer.addSublayer(preview)
    
    session.startRunning()
  }
  
  
}
