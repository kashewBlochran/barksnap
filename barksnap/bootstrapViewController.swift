//
//  bootstrapViewController.swift
//  barksnap
//
//  Created by matt on 4/29/17.
//  Copyright © 2017 BoulevardLabs. All rights reserved.
//

import UIKit
import CameraManager
import Photos

class bootstrapViewController: UIViewController {
    
    let cameraManager = CameraManager()
    var cameraPermission = false
    var photosPermission = false
    @IBOutlet weak var failText: UILabel!
    
    override func viewDidLoad() {
        askForCameraPermissionsAuto()
        askForPhotoLibraryPermissionsAuto()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     func askForCameraPermissionsAuto() {
        
        cameraManager.askUserForCameraPermission({ permissionGranted in
            if permissionGranted {
                //self.addCameraToView()
                print("camera permission granted")
                self.cameraPermission = true
            } else {
                print("camera permission denied")
                self.failText.text = "Camera and library access needed! Please update in iPhone Settings -> Barksnap."
            }
            if (self.cameraPermission == true && self.photosPermission == true){
                self.goBack()
            }

        })
    }
    
    //library permission (manual)
    func askForPhotoLibraryPermissionsAuto(){
        PHPhotoLibrary.requestAuthorization({ (autorizationStatus) in
            if autorizationStatus == .authorized {
                self.photosPermission = true
                print("library permission granted.")
            } else {
                print("library permission not granted.")
                self.failText.text = "Camera and library access needed! Please update in iPhone Settings -> Barksnap."
            }
            if (self.cameraPermission == true && self.photosPermission == true){
                self.goBack()
            }
        })
        
    }
    
    func goBack(){
        
        let tmpController :UIViewController! = self.presentingViewController;
        
        self.dismiss(animated: true, completion: {()->Void in
            tmpController.dismiss(animated: true, completion: nil);
        });
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
