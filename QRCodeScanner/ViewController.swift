//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by Lakshman Gurung on 21/11/17.
//  Copyright © 2017 Lakshman Gurung. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession = AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer!
    var captureDevice:AVCaptureDevice!
    var captureMetaOutput = AVCaptureMetadataOutput()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        let frameImgView = UIImageView(image: #imageLiteral(resourceName: "frame"))
        frameImgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frameImgView)
        
        NSLayoutConstraint(item: frameImgView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: frameImgView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        captureSession = AVCaptureSession()
        captureDevice = AVCaptureDevice.default(for: .video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
        } catch {
            
        }
        
        captureSession.addOutput(captureMetaOutput)
        captureMetaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetaOutput.metadataObjectTypes = [.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
        view.bringSubview(toFront: frameImgView)
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let metaObj = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            captureSession.stopRunning()
            
            let alertVC = UIAlertController(title: "QR Result", message: metaObj.stringValue! , preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self](action) in
                self?.captureSession.startRunning()
            }))
            present(alertVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

