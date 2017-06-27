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
    var treatArray = ["https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B000I82DTU&asins=B000I82DTU&linkId=0cbae9c2edd3791d13fb005b5a3fc9f6&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B00HQM0UMS&asins=B00HQM0UMS&linkId=7409c2a504c090be4d03527350d0fb9a&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=qf_sp_asin_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B00638222C&asins=B00638222C&linkId=ab0e66dc03be2391791d3bb7f30acee5&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=qf_sp_asin_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B016C72LK6&asins=B016C72LK6&linkId=9f6eeba3bff6ceefdfbe5de2984cad9b&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=qf_sp_asin_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B00CPDWT2M&asins=B00CPDWT2M&linkId=9dea3b2583558c7d079b1c1681209cbf&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=qf_sp_asin_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B06Y4F3TVT&asins=B06Y4F3TVT&linkId=1dd8a4a8a088518c964ba4ab3f6016a3&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=qf_sp_asin_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B00KNWVPFO&asins=B00KNWVPFO&linkId=ce52b7f9fade032b50e5cef03c86a2f0&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff", "https://ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=qf_sp_asin_til&ad_type=product_link&tracking_id=barksnap-20&marketplace=amazon&region=US&placement=B00WH8MEOS&asins=B00WH8MEOS&linkId=58b3f77b84893303d91b7613ca2288e0&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff"]
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
