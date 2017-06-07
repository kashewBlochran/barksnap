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
        
    //ui elements
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var upgradeText: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //camera
    let cameraManager = CameraManager()
    @IBOutlet weak var cameraView: UIView!
    
    //slider
    @IBOutlet weak var sliderBar: UISlider!
    
    //nav
    var swipeDown: UISwipeGestureRecognizer!
    
    //dynamic labels
    //@IBOutlet weak var resultLabel: UILabel!
    
    //product integration
    var activeProduct: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start elements faded
        upgradeText.alpha = 0.0
        upgradeButton.alpha = 0.0
        sliderBar.alpha = 0.0
        descriptionLabel.alpha = 0.0
        
        //slider thumb image
        sliderBar.setThumbImage(UIImage(named: "ShutterSmall"), for: UIControlState.normal)
    
        //swipe recognition
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
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
        
        //fade in labels
        UIView.animate(withDuration: 0.3, animations: {
            self.descriptionLabel.alpha = 1.0
        }) { (success) in
            UIView.animate(withDuration: 0.3, delay: 0.33, animations: {
                self.sliderBar.alpha = 1.0
            }) { (success) in
                print("done")
            }
        }


    }
    
    @IBAction func buy(_ sender: Any) {
        
        if let activeProduct = activeProduct{
            
            //disable buttons
            upgradeText.isEnabled = false
            upgradeButton.isEnabled = false
            
            //initiate payment
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
            
            //disable buttons
            upgradeText.isEnabled = false
            upgradeButton.isEnabled = false
            
            //initiate payment
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
            //animate
            UIView.animate(withDuration: 0.3, animations: {
                self.upgradeButton.alpha = 1.0
            }) { (success) in
                UIView.animate(withDuration: 0.3, delay: 0.33, animations: {
                    self.upgradeText.alpha = 1.0
                }) { (success) in
                    print("done")
                }
                
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            
            switch (transaction.transactionState){
                
            case .purchased:
                //finish payment
                SKPaymentQueue.default().finishTransaction(transaction)
                print("purchased")
                
                //reactivate gesture recognizer
                self.view.addGestureRecognizer(swipeDown)
                
                //set pro flag to true
                UserDefaults.standard.set(true, forKey: "pro")
                
                //update label
                descriptionLabel.text = "Purchase complete!"
                
                //return to previous screen
                goBack()
                
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("failed")
                
                //reactivate gesture recognizer
                self.view.addGestureRecognizer(swipeDown)
                
                //update label
                descriptionLabel.text = "Purchase failed! Please try again."
                
                //reactivate buttons
                upgradeText.isEnabled = true
                upgradeButton.isEnabled = true
                
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
