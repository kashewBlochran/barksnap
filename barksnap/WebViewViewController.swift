//
//  WebViewViewController.swift
//  barksnap
//
//  Created by matt on 4/23/17.
//  Copyright © 2017 BoulevardLabs. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var treatArray = ["https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B000I82DTU&asins=B000I82DTU&linkId=0cbae9c2edd3791d13fb005b5a3fc9f6&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B003PMQMK2&asins=B003PMQMK2&linkId=dbe408fcc3fdfb3aa0b5cd47a5571727&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B0042GLVDI&asins=B0042GLVDI&linkId=bf08c5db55aa711e92b040dd9561319f&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B010IU5B78&asins=B010IU5B78&linkId=4771296004e851e3ac02453dc0013bb8&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B00HQM0UMS&asins=B00HQM0UMS&linkId=7409c2a504c090be4d03527350d0fb9a&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff"]
    var currentIndex: Int!
    var url: NSURL!
    var requestObj: NSURLRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //randomize current index
        currentIndex = Int(arc4random_uniform(UInt32(treatArray.count)))
        
        //pull random URL from array
        url = NSURL (string: treatArray[currentIndex])!
        requestObj = NSURLRequest(url: url as URL);
        webView.loadRequest(requestObj as URLRequest)

        
    }
    @IBAction func back(_ sender: Any) {
        
        let tmpController :UIViewController! = self.presentingViewController;
        
        self.dismiss(animated: true, completion: {()->Void in
            tmpController.dismiss(animated: true, completion: nil);
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(_ sender: Any) {
        
        print("current index: \(currentIndex) out of \(treatArray.count)")
        
        if (currentIndex == treatArray.count - 1){
            
            currentIndex = 0
            
        } else {
            
            currentIndex = currentIndex + 1
            
        }
        
        url = NSURL (string: treatArray[currentIndex])!
        requestObj = NSURLRequest(url: url as URL);
        webView.loadRequest(requestObj as URLRequest)

    }
    
    @IBAction func previous(_ sender: Any) {
        
        print("current index: \(currentIndex) out of \(treatArray.count)")
        
        if (currentIndex == 0){
            
            currentIndex = 4
            
        } else {
            
            currentIndex = currentIndex - 1
            
        }
        
        url = NSURL (string: treatArray[currentIndex])!
        requestObj = NSURLRequest(url: url as URL);
        webView.loadRequest(requestObj as URLRequest)
        
        
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
