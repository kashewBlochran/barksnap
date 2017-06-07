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
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    let cameraManager = CameraManager()
    @IBOutlet weak var helpText: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    //universal audio variables
    var audioPlayer: AVAudioPlayer!
    var audioRatePitch: AVAudioUnitTimePitch!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile: AVAudioFile!
    
    //old audio var
    var player: AVAudioPlayer?

    
    //user defaults
    
    
    //var library: PHPhotoLibrary?
    
    let myAttribute = [
        NSForegroundColorAttributeName: UIColor.white,
        NSStrokeColorAttributeName: UIColor.black,
        NSStrokeWidthAttributeName: -1.0
        ] as [String : Any]
    
    var myAttrString: NSAttributedString!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fade all
        cameraButton.alpha = 0.0
        helpText.alpha = 0.0
        slider.alpha = 0.0
        
        //change slider image
        //slider thumb image
        slider.setThumbImage(UIImage(named: "ShutterSmall"), for: UIControlState.normal)

        //disable nav
        navigationController?.navigationBar.isHidden = false
        
        //don't auto-save images
        cameraManager.writeFilesToPhoneLibrary = false
        
        //init help text
         myAttrString = NSAttributedString(string: "Press and hold!", attributes: myAttribute)
        helpText.attributedText = myAttrString
        
        //disable auto permissions (handled elsewhere)
        cameraManager.showAccessPermissionPopupAutomatically = false
        
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
            audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
            
        } catch {
            print("error!")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addCameraToView()
        
        //turn volume up only if permissions to camera & photos authorized.
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            //check system volume
            let volume = AVAudioSession.sharedInstance().outputVolume;
            print(volume)
            
            //turn volume up
            (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1, animated: false)
        }
        
        
        cameraButton.setImage(UIImage(named: "Shutter.png"), for: UIControlState.normal)
        cameraButton.isEnabled = true
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let pro = UserDefaults.standard.bool(forKey: "pro")
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore  {
            print("Not first launch.")
            print("pro version (not first launch): \(pro)")
            //performSegue(withIdentifier: "onboard", sender: self)
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(false, forKey: "pro")
            print("pro version (inside first launch sequence): \(pro)")
            performSegue(withIdentifier: "bootstrapSegue", sender: self)
        }
        
        if pro == true {
            
            //fade regular button
            cameraButton.alpha = 0.0
            
            //deactivate regular button
            cameraButton.isEnabled = false
            
            //enable slider
            slider.isEnabled = true
            
            //fade in slider
            UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
                self.slider.alpha = 1.0
            }) { (success) in
                print("slider faded in.")
            }

        } else {
            
            //fade slider
            slider.alpha = 0.0
            
            //deactivate slider
            slider.isEnabled = false
            
            //fade in regular button and help text.
            UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
                self.cameraButton.alpha = 1.0
            }) { (success) in
                UIView.animate(withDuration: 0.3, delay: 0.43, animations: {
                    self.helpText.alpha = 1.0
                }) { (success) in
                    print("done")
                }
            }
        }
    }
    
    //press regular button
    func playSound() {
        
        audioPlayerNode.play()
        
    }
    
    func stopSound(){
        
       audioPlayerNode.stop()
        
    }
    
    //press pro slider
    @IBAction func sliderPress(_ sender: Any) {
        
        //schedule file
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        //play
        playSound()
        
    }
    
    //release pro slider (finger inside)
    @IBAction func sliderReleaseInside(_ sender: Any) {
        
        //disable slider
        slider.isEnabled = false
        
        //stop sound
        stopSound()
        
        //take picture
        takePicture()
        
    }
    
    //release pro slider (finger outside)
    @IBAction func sliderReleaseOutside(_ sender: Any) {
        
        //disable slider
        slider.isEnabled = false
        
        //stop sound
        stopSound()
        
        //take picture
        takePicture()
        
    }
    
    //pro slider value change
    @IBAction func sliderValueChange(_ sender: Any) {
        
        print(slider.value)
        
        audioRatePitch.pitch = slider.value*750
        audioRatePitch.rate = 1.0
        audioPlayerNode.play()
        
    }
    
    fileprivate func addCameraToView() {
        
        print(cameraManager.addPreviewLayerToView(self.cameraView))
        
    }
    
    @IBAction func buttonDown(_ sender: UIButton) {
        
        //play sound
        playSound()
        
        //change image to button pressed
        cameraButton.setImage(UIImage(named: "Shutter_Press.png"), for: UIControlState.normal)
        
        //change help text to "release"
        myAttrString = NSAttributedString(string: "Release!", attributes: myAttribute)
        helpText.attributedText = myAttrString
        
    }
    
    @IBAction func buttonRelease(_ sender: UIButton) {
        
        //change image back to normal
        cameraButton.setImage(UIImage(named: "Shutter.png"), for: UIControlState.normal)
        
        //stop sound
        stopSound()
        
        //disable button
        cameraButton.isEnabled = false
        
        //hide help text
        helpText.isHidden = true
        
        //snap picture
        takePicture()
        
//        cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
//            if let errorOccured = error {
//                self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
//            }
//            else {
//                let vc: ImageViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as? ImageViewController
//                if let validVC: ImageViewController = vc {
//                    if let capturedImage = image {
//                        validVC.image = capturedImage
//                        self.navigationController?.pushViewController(validVC, animated: true)
//                    }
//                }
//            }
//        })
//        
        
    }
    
    func takePicture(){
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
