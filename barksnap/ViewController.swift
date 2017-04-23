//
//  ViewController.swift
//  barksnap
//
//  Created by matt on 1/9/17.
//  Copyright © 2017 BoulevardLabs. All rights reserved.
//

import UIKit
import CameraManager
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    let cameraManager = CameraManager()
    @IBOutlet weak var helpText: UILabel!
    
    let myAttribute = [
        NSForegroundColorAttributeName: UIColor.white,
        NSStrokeColorAttributeName: UIColor.black,
        NSStrokeWidthAttributeName: -1.0
        ] as [String : Any]
    
    var myAttrString: NSAttributedString!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            performSegue(withIdentifier: "onboard", sender: self)
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            performSegue(withIdentifier: "onboard", sender: self)
        }
        
        
        
        cameraButton.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.cameraButton.alpha = 1.0
        })
        
        //check system volume
        let volume = AVAudioSession.sharedInstance().outputVolume;
        print(volume)
        
        //turn volume up
        (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1, animated: false)

        //disable nav
        navigationController?.navigationBar.isHidden = false
        
        //don't auto-save images
        cameraManager.writeFilesToPhoneLibrary = false
        
        //help text
         myAttrString = NSAttributedString(string: "Press and hold!", attributes: myAttribute)
        helpText.attributedText = myAttrString
        
        //camera
        cameraManager.showAccessPermissionPopupAutomatically = true
        addCameraToView()
        
        //animation
//        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
//        pulseAnimation.duration = 1.0
//        pulseAnimation.toValue = NSNumber(value: 1.0)
//        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        pulseAnimation.autoreverses = true
//        pulseAnimation.repeatCount = FLT_MAX
//        
//        self.helpText.layer.add(pulseAnimation, forKey: nil)
    
    }

    var player: AVAudioPlayer?
    
    func playSound() {
        let url = Bundle.main.url(forResource: "whistle", withExtension: "wav")!
        
        //from site
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        cameraButton.setImage(UIImage(named: "Shutter.png"), for: UIControlState.normal)
        cameraButton.isEnabled = true
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    
    fileprivate func addCameraToView()
    {
        
        print(cameraManager.addPreviewLayerToView(self.cameraView))
        
    }
    
    @IBAction func buttonDown(_ sender: UIButton) {
        
        print("button pressed")
        playSound()
        cameraButton.setImage(UIImage(named: "Shutter_Press.png"), for: UIControlState.normal)
        myAttrString = NSAttributedString(string: "Release!", attributes: myAttribute)
        helpText.attributedText = myAttrString
        
    }
    
    @IBAction func buttonRelease(_ sender: UIButton) {
        
        cameraButton.setImage(UIImage(named: "Shutter.png"), for: UIControlState.normal)
        
        print("button released")
        //stop sound
        player?.stop()
        
        cameraButton.isEnabled = false
        
        helpText.isHidden = true
        
        cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
            if let errorOccured = error {
                self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
            }
            else {
                let vc: ImageViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as? ImageViewController
                if let validVC: ImageViewController = vc {
                    if let capturedImage = image {
                        validVC.image = capturedImage
                        self.navigationController?.pushViewController(validVC, animated: true)
                    }
                }
            }
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
