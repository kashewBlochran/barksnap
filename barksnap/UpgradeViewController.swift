//
//  UpgradeViewController.swift
//  barksnap
//
//  Created by matt on 5/31/17.
//  Copyright © 2017 BoulevardLabs. All rights reserved.
//

import UIKit
import StoreKit
import AVFoundation
import CameraManager

class UpgradeViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    //audio
    var audioPlayer: AVAudioPlayer!
    var audioRatePitch: AVAudioUnitTimePitch!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    
    //camera
    let cameraManager = CameraManager()
    @IBOutlet weak var cameraView: UIView!
    
    //slider
    @IBOutlet weak var sliderBar: UISlider!
    
    //nav
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
    
    //dynamic labels
    //@IBOutlet weak var resultLabel: UILabel!
    
    //product integration
    var activeProduct: SKProduct?
    
    @IBAction func buy(_ sender: Any) {
        
        if let activeProduct = activeProduct{
            self.view.removeGestureRecognizer(swipeDown)
            print("buying product \(activeProduct.productIdentifier)")
            let payment = SKPayment(product: activeProduct)
            SKPaymentQueue.default().add(payment)
            
        } else {
            
            print("no product!")
            
        }
        
    }
    
    @IBAction func sliderTouchDown(_ sender: Any) {
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        audioPlayerNode.play()
        
    }
    
    @IBAction func sliderTouchUpInside(_ sender: Any) {
        
        audioPlayerNode.stop()
        
    }
    
    @IBAction func sliderTouchUpOutside(_ sender: Any) {
       
        audioPlayerNode.stop()
        
    }
    
    
    @IBAction func slider(_ sender: Any) {
        
        print(sliderBar.value)
        
        audioRatePitch.pitch = sliderBar.value*750
        audioRatePitch.rate = 1.0
        
        //audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        audioPlayerNode.play()
        
    }
    
    @IBAction func buyButton(_ sender: Any) {
        
        if let activeProduct = activeProduct{
            self.view.removeGestureRecognizer(swipeDown)
            print("buying product \(activeProduct.productIdentifier)")
            let payment = SKPayment(product: activeProduct)
            SKPaymentQueue.default().add(payment)
            
        } else {
            
            print("no product!")
            
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("loading products...")
        
        for product in response.products {
            
            print("Product: \(product.productIdentifier), \(product.localizedTitle), \(product.price.floatValue)")
            
            activeProduct = product
            //resultLabel.text = activeProduct?.localizedTitle
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            
            switch (transaction.transactionState){
                
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("purchased")
                self.view.addGestureRecognizer(swipeDown)
                //resultLabel.text = "Purchase complete!"
                //apply purchase here, store data in user defaults.
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("failed")
                self.view.addGestureRecognizer(swipeDown)
                //resultLabel.text = "Failed!"
            default:
                break
            }
        }
    }
    
    //add camera to view
    fileprivate func addCameraToView()
    {
        
        print(cameraManager.addPreviewLayerToView(self.cameraView))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //swipe recognition
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
  
        //init audio
        let url = Bundle.main.url(forResource: "whistle", withExtension: "wav")!
        
        do {
          try audioPlayer = AVAudioPlayer(contentsOf: url)
          audioPlayer.enableRate = true
            
            //create audio engine
            audioEngine = AVAudioEngine()
            audioRatePitch = AVAudioUnitTimePitch()
            audioPlayerNode = AVAudioPlayerNode()
            
            audioEngine.attach(audioRatePitch)
            audioEngine.attach(audioPlayerNode)
            
            audioEngine.connect(audioPlayerNode, to: audioRatePitch, format: nil)
            audioEngine.connect(audioRatePitch, to: audioEngine.outputNode, format: nil)
            
            try audioFile = AVAudioFile(forReading: url)
            try audioEngine.start()
            
        } catch {
            print("error!")
        }
        
        //payments
        SKPaymentQueue.default().add(self)
        let productIdentifiers: Set<String> = ["com.bsprotest"]
        let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //add camera
        addCameraToView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func goBack(){
        
        let tmpController :UIViewController! = self.presentingViewController;
        
        self.dismiss(animated: true, completion: {()->Void in
            tmpController.dismiss(animated: true, completion: nil);
        });
        
    }
    
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.down:
                goBack()
            case UISwipeGestureRecognizerDirection.up:
                goBack()
                
            default:
                break
            }
        }
        
    }
    

}
