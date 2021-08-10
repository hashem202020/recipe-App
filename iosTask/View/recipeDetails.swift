//
//  recipeDetails.swift
//  iosTask
//
//  Created by apple on 8/4/21.
//

import UIKit
import SafariServices

class recipeDetails: UIViewController {

    @IBOutlet weak var topConstrainDetailsView: NSLayoutConstraint!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var imgURL : String?
    var recipeName: String?
    var ingredientLines: [String]?
    var ingredientText = ""
    var recipeURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiHandler()
    }
    
    //MARK:- uiHandlers
    func uiHandler(){
        viewDownUiHandler()

        recipeImage.loadImage(URL(string: imgURL ?? ""))
        titleLabel.text = recipeName
        
        for line in ingredientLines ?? []{
            ingredientText += line + "\n\n"
        }
        detailsTextView.text = ingredientText
    }
    
    
    //MARK:- swipe funcs
    /// this function handling ui when swipe the details view up
    func viewUpUiHandler(){
        self.topConstrainDetailsView.constant = 0
        detailsView.layer.cornerRadius = 0
        detailsTextView.isScrollEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.detailsView.layoutIfNeeded()
        }
    }
    
    /// this function handling ui when swipe the details view down
    func viewDownUiHandler(){
        self.topConstrainDetailsView.constant = 250
        detailsView.layer.cornerRadius = 15
        detailsView.layer.maskedCorners = [ .layerMaxXMinYCorner , .layerMinXMinYCorner]
        detailsTextView.isScrollEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.detailsView.layoutIfNeeded()
        }
    }
    
    
    //MARK:- shareURl func
    /// this function for sharing recipe url to the available sharing options on the device
    /// - Parameter url: the Url  wanted to share
    func shareRecipeUrl(url: String){
        let linkToShare = url
        let textToShare = [ linkToShare ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: [])
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        if UIDevice.current.userInterfaceIdiom == .pad {
        activityViewController.popoverPresentationController?.sourceRect =   recipeImage.bounds //so the ipad will not crash
        activityViewController.popoverPresentationController?.permittedArrowDirections = .up
        }else{
            activityViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        }
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook , UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.mail, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.message]

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- swipe up
    @IBAction func viewSwipedUp(_ sender: Any) {
        viewUpUiHandler()
    }
    
    //MARK:- swipe down
    @IBAction func viewSwipedDown(_ sender: Any) {
        viewDownUiHandler()
    }
    
    //MARK:- Open website
    @IBAction func websiteButtonPressed(_ sender: Any) {
        if let url = URL(string: recipeURL ?? "www.google.com") {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK:- share reciepe link
    @IBAction func shareButtonPressed(_ sender: Any) {
       shareRecipeUrl(url: recipeURL ?? "")
    }
    
}
