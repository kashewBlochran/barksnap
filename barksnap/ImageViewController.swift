//
//  ImageViewController.swift
//  barksnap
//
//  Created by matt on 1/9/17.
//  Copyright © 2017 BoulevardLabs. All rights reserved.
//

import UIKit
import Social

class ImageViewController: UIViewController, STADelegateProtocol {
    @IBOutlet weak var bar: UIToolbar!

    @IBOutlet weak var bannerlogo: UIImageView!
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    var watermarkedImage: UIImage?
    @IBOutlet weak var save: UIBarButtonItem!
    @IBOutlet weak var saved: UIImageView!
    @IBOutlet weak var upgradeLabel: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        saved.alpha = 0.0

       // navigationController?.navigationBar.isHidden = false
       //navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80.0)
        
        //bar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 80.0)

        //if image is coming in from other VC...
        if let validImage = self.image {

        //set imageview to valid image
            self.imageView.image = validImage
            
            let logoImage = UIImage(named: "Barksnap_Logo_URL_large.png")

            
        //watermark...
        //self.watermarkedImage = self.textToImage(drawText: "Barksnap.com", inImage: validImage, atPoint: CGPoint(x: 20, y: 20))
            
            self.watermarkedImage = self.logoToImage(addLogo: logoImage!, inImage: validImage, atPoint: CGPoint(x: 20, y: 20))
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //pro?
        let pro = UserDefaults.standard.bool(forKey: "pro")
        
        //if pro: hide upgrade button
        if pro {
            
            upgradeLabel.isHidden = true
            
        }
        
    }
    
    @IBAction func loadAd(_ sender: Any) {
        
        
    }
    
    //watermark image and return
    func logoToImage(addLogo logo: UIImage, inImage image: UIImage, atPoint point: CGPoint) ->
        UIImage {
            
            //scale of main screen
            let scale = UIScreen.main.scale
            
            //start graphics engine?
            UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
            
            //fuck with more font shit
            
            //draw a rectangle on current image (validImage)
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
            
            //draw a second rectangle, but name this bitch
            let rect = CGRect(origin: point, size: logo.size)
            
            
            //draw logo inside of rectangle
            logo.draw(in: rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
            
    }
    
    //press to share an image...
    @IBAction func action(_ sender: UIButton) {
        
        // set up activity view controller
        //let msg = "Snapped with Barksnap, the dog whistle camera app. www.barksnap.com"
        
        //let sharedObjects:[AnyObject] = [watermarkedImage!]
        let wmImage = watermarkedImage!
        
        
        let activityViewController = UIActivityViewController(activityItems: [(wmImage)], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types
        activityViewController.excludedActivityTypes = [
            
                                                         UIActivityType.addToReadingList,
                                                         UIActivityType.print,
                                                         UIActivityType.assignToContact,
                                                         UIActivityType.saveToCameraRoll,
                                                         UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")
                                                          ]
        
        activityViewController.completionWithItemsHandler = {
        
            activity, success, items, error in
            self.performSegue(withIdentifier: "treatSegue", sender: nil)
        
        }
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    var documentsInteractionsController = UIDocumentInteractionController()
    
    //custom share menu
    @IBAction func showShareOptions(sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "", message: "Share with friends!", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // Configure a new action for sharing the note in Twitter.
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.default) { (action) -> Void in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
                twitterComposeVC?.setInitialText("Snapped with Barksnap, the dog-whistle Camera app!")
                twitterComposeVC?.add(self.watermarkedImage)
                twitterComposeVC?.add(URL(string: "http://www.barksnap.com"))
                
                self.present(twitterComposeVC!, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Twitter not installed", message: "You need the Twitter app installed to use this feature.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok.", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }

            
        }
        
        //share on insta action
        let shareOnInstagram = UIAlertAction(title: "Share on Instagram", style: UIAlertActionStyle.default) { (action) -> Void in
            
            //third attempt
            let instagramUrl = URL(string: "instagram://app")!
            if UIApplication.shared.canOpenURL(instagramUrl) {
                let imageData = UIImageJPEGRepresentation(self.watermarkedImage!, 1.0)!
                //let captionString = text ?? ""
                
                //let writePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendPathComponent("instagram.igo")
                let writePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("instagramonly.igo")
                //var finishedPath = writePath.appendPathComponent("instagram.igo")
            
                //let writePath = URL(fileURLWithPath: NSTemporaryDirectory())!.appendingPathComponent("instagram.igo")
                do {
                    print("write path: \(writePath)")
                    try imageData.write(to: writePath)
                    self.documentsInteractionsController.url = writePath
                    self.documentsInteractionsController.uti = "com.instagram.exclusivegram"
                    self.documentsInteractionsController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
                }catch {
                    return
                }
            }else {
                let alertController = UIAlertController(title: "Instagram not installed", message: "You need Instagram app installed to use this feature.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok.", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
         
        }
        
        // Configure a new action to share on Facebook.
        let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.default) { (action) -> Void in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                //facebookComposeVC?.setInitialText("Snapped with Barksnap, the dog-whistle Camera app!")
                facebookComposeVC?.add(self.watermarkedImage)
                //facebookComposeVC?.add(URL(string: "http://www.barksnap.com"))
                
                self.present(facebookComposeVC!, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Facebook not installed", message: "You need Instagram app installed to use this feature.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok.", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        actionSheet.addAction(shareOnInstagram)
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(dismissAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    

    //when save button pressed, save watermarked image, then show ad.
    @IBAction func save(_ sender: UIButton) {
        
        UIImageWriteToSavedPhotosAlbum(watermarkedImage!, nil, nil, nil);
        
        
        UIView.animate(withDuration: 0.3, animations: {
                self.saved.alpha = 1.0
        }) { (success) in
            UIView.animate(withDuration: 0.3, delay: 1.0, animations: {
                self.saved.alpha = 0.0
            }) { (success) in
                self.performSegue(withIdentifier: "treatSegue", sender: nil)
        }
        
        }}
    
    //when ad closes...
    func didClose(_ ad: STAAbstractAd!) {
        
        //_ = self.navigationController?.popViewController(animated: true)
        print("ad finished.")
        
    }
    
    //if help is needed...
    @IBAction func help(_ sender: UIButton) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
